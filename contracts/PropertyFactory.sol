pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/IERC20.sol";

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}

contract PropertyToken is IERC20 {
    using SafeMath for uint256;

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint256 private _totalSupply;
    uint256 public tokenEthPrice;
    address payable public owner;

    mapping(address => uint256) private balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    constructor(string memory _symbol, string memory _name, uint256 _initialSupply, uint256 _tokenEthPrice, address payable _owner) public {
        symbol = _symbol;
        name = _name;
        decimals = 0;
        _totalSupply = _initialSupply * 10**uint(decimals);
        tokenEthPrice = _tokenEthPrice * 1 ether;
        owner = _owner;
        balances[_owner] = _totalSupply;
        emit Transfer(address(0), _owner, _totalSupply);
    }
    
    /**
     * @dev See `IERC20.totalSupply`.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[owner] = balances[owner].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        _allowances[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return _allowances[tokenOwner][spender];
    }

    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
        _allowances[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        return true;
    }
    
    function buyTokens() public payable {
        require(msg.sender != owner);
        
        uint256 exchangeRate = 500;
        uint256 tokens = exchangeRate.mul(msg.value).div(1 ether);
        
        require(tokens > 0);
        require(tokens <= _totalSupply);
        
        transfer(msg.sender, tokens);
        owner.transfer(msg.value);
    }
    
    function myBalance() public view returns (uint balance) {
        return balances[msg.sender];
    }
    
    function () external payable {
        revert();
    }
}

contract PropertyTokenFactory {
    event NewToken(address _contract);
    
    address[] public tokens;
    uint256 private numberOfTokens;

    function createProperty(string memory _symbol, string memory _name, uint256 _supplyOfTokens, uint256 _tokenEthPrice, address payable _owner) public returns (address) {
        PropertyToken tokenContract = new PropertyToken(_symbol, _name, _supplyOfTokens, _tokenEthPrice, _owner);
        
        tokens.push(address(tokenContract));
        numberOfTokens++;
        
        emit NewToken(address(tokenContract));
    }
    
    function totalTokens() public view returns(uint256) {
        return numberOfTokens;
    }
}
