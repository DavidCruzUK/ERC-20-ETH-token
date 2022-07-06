pragma solidity 0.8.15;

/// ERC-20
/// @title A title that should describe the contract/interface
/// @author davthecoder
/// @notice Explain to an end user what this does
/// @dev Explain to a developer any extra details

abstract contract ERC20Token {
    function name() public view returns (string);
    function symbol() public view returns (string);
    function decimals() public view returns (uint8);
    function totalSupply() public view returns (uint256);
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract Owned {
    address public _owner;
    address public _newOwner;
    
    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor () {
        _owner = msg.sender;
    }

    function transferOwnership(address _to) public {
        require(msg.sender == _owner);
        _newOwner = _to;
    }

    function acceptOwership() public {
        require(msg.sender == _newOwner);
        emit OwnershipTransferred(_owner, _newOwner);
        _owner = _newOwner;
        _newOwner = address(0);
    }
}

contract Token is ERC20Token, Owned {
    /// Create contract specs
}