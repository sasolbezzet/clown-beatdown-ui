// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

/// @title Simple ERC20 token (no external imports) for testing
/// @notice Minimal ERC20 implementation sufficient for deployment and basic interactions.
contract ClownToken {
    string public name = "Clown Token";
    string public symbol = "CLOWN";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 _initialSupply) {
        _mint(msg.sender, _initialSupply);
    }

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
        require(allowed >= _value, "ERC20: transfer amount exceeds allowance");
        allowance[_from][msg.sender] = allowed - _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0), "ERC20: transfer to zero address");
        uint256 fromBalance = balanceOf[_from];
        require(fromBalance >= _value, "ERC20: transfer amount exceeds balance");
        balanceOf[_from] = fromBalance - _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    function _mint(address _account, uint256 _amount) internal {
        require(_account != address(0), "ERC20: mint to zero address");
        totalSupply += _amount;
        balanceOf[_account] += _amount;
        emit Transfer(address(0), _account, _amount);
    }
}
