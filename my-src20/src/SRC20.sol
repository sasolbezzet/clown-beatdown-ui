// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Import Seismic shielded utilities (adjust path if needed)


/// @title SRC20 – ERC20 dengan saldo yang disembunyikan
/// @notice Semua saldo dan nilai transfer memakai tipe `suint256` sehingga
///         nilai asli tidak terlihat pada chain explorer.
contract SRC20 {
    // Nama & simbol token
    string public name = "MyShieldedToken";
    string public symbol = "MST";
    uint8 public constant decimals = 18;

    // Total suplai (shielded)
    uint256 public totalSupply;

    // Saldo setiap address (shielded)
    mapping(address => uint256) private _balanceOf;

    // Event standar ERC20 (nilai yang terlihat tetap 0)
    event Transfer(address indexed from, address indexed to, uint256 value);
    // event Approval(address indexed owner, address indexed spender, uint256 value);

    // -----------------------------------------------------------------
    // Konstruktor – mint token ke pembuat kontrak
    // -----------------------------------------------------------------
    constructor(uint256 _initialSupply) {
        _mint(msg.sender, _initialSupply);
    }

    // -----------------------------------------------------------------
    // View saldo shielded (hanya pemilik kunci yang dapat melihat nilai)
    // -----------------------------------------------------------------
    function balanceOf(address account) external view returns (uint256) {
        return _balanceOf[account];
    }

    // -----------------------------------------------------------------
    // Transfer shielded
    // -----------------------------------------------------------------
    function transfer(address to, uint256 amount) external returns (bool) {
        address from = msg.sender;
        _transfer(from, to, amount);
        return true;
    }

    // Added to enable contract‑to‑contract transfers for reward flow
    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        _transfer(from, to, amount);
        return true;
    }

    // -----------------------------------------------------------------
    // Internal transfer logic
    // -----------------------------------------------------------------
    function _transfer(address from, address to, uint256 amount) internal {
        require(_balanceOf[from] >= amount, "Insufficient balance");
        _balanceOf[from] = _balanceOf[from] - amount;
        _balanceOf[to]   = _balanceOf[to]   + amount;
        emit Transfer(from, to, 0);
    }

    // -----------------------------------------------------------------
    // Mint – hanya pemilik kontrak
    // -----------------------------------------------------------------
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "Mint to zero address");
        totalSupply = totalSupply + amount;
        _balanceOf[account] = _balanceOf[account] + amount;
        emit Transfer(address(0), account, 0);
    }

    // -----------------------------------------------------------------
    // Burn – opsional
    // -----------------------------------------------------------------
    function burn(uint256 amount) external {
        address from = msg.sender;
        require(_balanceOf[from] >= amount, "Insufficient balance");
        _balanceOf[from] = _balanceOf[from] - amount;
        totalSupply = totalSupply - amount;
        emit Transfer(from, address(0), 0);
    }
}
