// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

/// @title PrivateSRC20 – minimal ERC‑20 token with owner‑only minting
/// @notice Only the contract deployer (owner) can mint new tokens. No public transfer restrictions.
contract PrivateSRC20 {
    // Token metadata
    string public name = "Private SRC20";
    string public symbol = "PRV20";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    // Owner address (deployer)
    address public owner;

    // Balances and allowances
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed from, uint256 amount);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // ---------- ERC20 standard functions ----------
    function transfer(address _to, uint256 _value) external returns (bool) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
        uint256 allowed = allowance[_from][msg.sender];
        require(allowed >= _value, "ERC20: insufficient allowance");
        allowance[_from][msg.sender] = allowed - _value;
        _transfer(_from, _to, _value);
        return true;
    }

    // ---------- Owner‑only mint / burn ----------
    function mint(address _to, uint256 _amount) external onlyOwner {
        require(_to != address(0), "ERC20: mint to zero address");
        totalSupply += _amount;
        balanceOf[_to] += _amount;
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
    }

    function burn(uint256 _amount) external {
        uint256 bal = balanceOf[msg.sender];
        require(bal >= _amount, "ERC20: burn amount exceeds balance");
        balanceOf[msg.sender] = bal - _amount;
        totalSupply -= _amount;
        emit Burn(msg.sender, _amount);
        emit Transfer(msg.sender, address(0), _amount);
    }

    // ---------- internal helpers ----------
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0), "ERC20: transfer to zero address");
        uint256 fromBal = balanceOf[_from];
        require(fromBal >= _value, "ERC20: transfer amount exceeds balance");
        balanceOf[_from] = fromBal - _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }
}
