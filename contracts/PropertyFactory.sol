pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/IERC20.sol";

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}

contract PropertyToken is IERC20 {
    using SafeMath for uint;

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint256 public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor(string memory _symbol, string memory _name, uint _initialSUpply, address _owner) public {
        symbol = _symbol;
        name = _name;
        decimals = 18;
        _totalSupply = _initialSUpply * 10**uint(decimals);
        balances[_owner] = _totalSupply;
        emit Transfer(address(0), _owner, _totalSupply);
    }
    
    function totalSupply() public view returns (uint) {
        return _totalSupply.sub(balances[address(0)]);
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        return true;
    }

    function () external payable {
        revert();
    }
}

contract PropertyTokenFactory {
    event NewToken(address _contract);
    
    address[] public tokens;
    uint256 private numberOfTokens;

    function createProperty(string memory _symbol, string memory _name, uint _supplyOfTokens, address _owner) public returns (address) {
        PropertyToken tokenContract = new PropertyToken(_symbol, _name, _supplyOfTokens, _owner);
        
        tokens.push(address(tokenContract));
        numberOfTokens++;
        
        emit NewToken(address(tokenContract));
    }
    
    function totalTokens() public view returns(uint256) {
        return numberOfTokens;
    }
}
