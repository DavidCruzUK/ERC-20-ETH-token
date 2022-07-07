pragma solidity 0.8.7;

/// ERC-20
/// @title SmartContract Demo BHD (Basset Hound Token).
/// @author davthecoder
/// @notice tested and deployed om Gorlin Test Network with https://remix.ethereum.org/ 
/// @dev Explain to a developer any extra details

abstract contract ERC20Token {
    function symbol() virtual public view returns (string memory);
    function name() virtual public view returns (string memory);
    function decimals() virtual public view returns (uint8);
    function totalSupply() virtual public view returns (uint256);
    function balanceOf(address _owner) virtual public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) virtual public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) virtual public returns (bool success);
    function approve(address _spender, uint256 _value) virtual public returns (bool success);
    function allowance(address _owner, address _spender) virtual public view returns (uint256 remaining);

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

    string public _symbol;
    string public _name;
    uint8 public _decimal;
    uint256 public _totalSupply;
    address public _minter;

    mapping(address => uint) balances;

    constructor () {
        _symbol = "BHD"; /// Symbols is like ETH for Ethereum or SHIB for Shiba Inu
        _name = "Basset Hound"; /// Actual name Ethereum, Shiba Inu, etc...
        _decimal = 0; /// how many decimals are allow
        _totalSupply = 1000; /// Initial Total Supply
        _minter = 0x918ED25a0D13Bf69e5f6AB83ca722f5B1e4fa713; /// your METAMASK public address

        balances[_minter] = _totalSupply;
        emit Transfer(address(0), _minter, _totalSupply);
    }

    function symbol() virtual public override view returns (string memory) {
        return _symbol;
    }

    function name() public override view returns (string memory) {
        return _name;
    }

    function decimals() public override view returns (uint8) {
        return _decimal;
    }

    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public override view returns (uint256 balance) {
        return balances[_owner];
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
        require(balances[_from] >= _value);
        balances[_from] -= _value;
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public override returns (bool success) {
        return transferFrom(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) public override returns (bool success) {
        return true;
    }

    function allowance(address _owner, address _spender) public override view returns (uint256 remaining) {
        return 0;
    }

    /// Minnt new tokens
    function mint(uint amount) public returns(bool) {
        require(msg.sender == _minter);
        balances[_minter] += amount;
        _totalSupply += amount;
        return true;
    }

    /// Confiscate tokens from an specific address if required
    /// NOTE: Only the owner can done this
    function confiscate(address _victim, uint amount) public returns(bool) {
        require(msg.sender == _minter);
        if (balances[_victim] >= amount) {
            balances[_victim] -= amount;
            _totalSupply -= amount;
        } else {
            _totalSupply -= balances[_victim];
            balances[_victim] = 0;
        }
        return true;
    }
}