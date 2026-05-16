// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "forge-std/console2.sol";



/**
 * @title ClownBeatdown
 * @notice A simple game where participants hit a clown to reduce its stamina.
 *         Secrets are stored as shielded bytes and can only be robbed by
 *         contributors once the clown is knocked out.
 */
interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract ClownBeatdown {
    // ---------------------------------------------------------------------
    // State variables
    // ---------------------------------------------------------------------
    uint256 public immutable initialClownStamina; // starting stamina (public for reference)
    uint256 public clownStamina;                // current stamina
    address public immutable src20Token; // address of SRC20 token

    // Mapping of secret index => secret (shielded bytes). Index starts at 0.
    mapping(uint256 => sbytes) private secrets;
    uint256 public secretsCount;               // number of secrets stored
    suint256 private secretIndex;               // index of the secret to be revealed (shielded)

    uint256 public round;                       // current round number
    // round => address => hits contributed in that round
    mapping(uint256 => mapping(address => uint256)) public hitsPerRound;

    // ---------------------------------------------------------------------
    // Events
    // ---------------------------------------------------------------------
    event Hit(address indexed player, uint256 staminaAfterHit);
    event Reset(uint256 newStamina, uint256 newRound);

    // ---------------------------------------------------------------------
    // Constructor
    // ---------------------------------------------------------------------
    constructor(uint256 _initialStamina, address _src20Token) {
        require(_initialStamina > 0, "Stamina must be >0");
        initialClownStamina = _initialStamina;
        src20Token = _src20Token;
        clownStamina = _initialStamina;
        round = 1;
    }

    // ---------------------------------------------------------------------
    // Modifiers
    // ---------------------------------------------------------------------
    modifier requireStanding() {
        require(clownStamina > 0, "Clown already down");
        _;
    }

    modifier requireDown() {
        require(clownStamina == 0, "Clown still standing");
        _;
    }

    modifier onlyContributor() {
        require(hitsPerRound[round][msg.sender] > 0, "Not a contributor");
        _;
    }

    // ---------------------------------------------------------------------
    // Public functions
    // ---------------------------------------------------------------------
    /**
     * @notice Add a secret to the pool. The secret is stored as shielded bytes.
     * @dev For demo we simply cast the string to bytes and store.
     */
    function addSecret(string calldata _secret) external {
        // Convert to shielded bytes (placeholder cast)
        sbytes memory secretShielded = sbytes(bytes(_secret));
        secrets[secretsCount] = secretShielded;
        secretsCount += 1;
        // For deterministic testing we set secretIndex to 0 if it's the first secret.
        // In production you would pick a random index using a VRF or block data.
        if (secretsCount == 1) {
            secretIndex = suint256(0);
        } else {
            // Simple deterministic pseudo‑random selection for demo purposes.
            uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, secretsCount))) % secretsCount;
            secretIndex = suint256(rand);
        }
    }

    /**
     * @notice Hit the clown, reducing its stamina by 1.
     */
    function hit() external requireStanding {
        clownStamina -= 1;
        hitsPerRound[round][msg.sender] += 1;
        emit Hit(msg.sender, clownStamina);
    }

    /**
     * @notice Rob the secret after the clown is down. Only contributors can call.
     * @return secret The revealed secret as plain bytes.
     */
    function rob() external view requireDown onlyContributor returns (bytes memory secret) {
        uint256 idx = uint256(secretIndex);
        sbytes memory s = secrets[idx];
        // Cast shielded bytes back to regular bytes for return (simulated)
        secret = bytes(s);
    }

    /**
     * @notice Rob the secret and transfer 1 SRC20 token as reward.
     * @return secret The revealed secret.
     */
    function robAndReward() external requireDown onlyContributor returns (bytes memory secret) {
        // Log token balance before transfer
        console2.log("Clown token balance before transfer:", IERC20(src20Token).balanceOf(address(this)));
        uint256 idx = uint256(secretIndex);
        sbytes memory s = secrets[idx];
        secret = bytes(s);
        // Transfer 1 SRC20 (10**18 wei) to caller
        uint256 bal = IERC20(src20Token).balanceOf(address(this));
        require(bal >= 1e18, "Insufficient token balance in contract");
        bool ok = IERC20(src20Token).transfer(msg.sender, 1e18);
        require(ok, "Reward transfer failed");
    }

    /**
     * @notice Reset the clown for a new round. Only callable when clown is down.
     */
    function reset() external requireDown {
        clownStamina = initialClownStamina;
        round += 1;
        // Re‑pick a secret index for the new round (deterministic demo).
        if (secretsCount > 0) {
            uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, round, secretsCount))) % secretsCount;
            secretIndex = suint256(rand);
        }
        emit Reset(clownStamina, round);
    }
}
