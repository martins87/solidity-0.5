pragma solidity >= 0.5.0 <0.6.0;
// 1000000000000000000

import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol";

contract Movie {
    using SafeMath for uint256;
    
    address private owner;
    bool public isFunded;
    uint256 public total;
    uint256 public totalShares;
    mapping(address => uint256) shares;
    address payable[] public shareHolders;
    
    constructor(uint256 _total) public {
        owner = msg.sender;
        total = _total;
    }
    
    function addFund() public payable{
        require(!isFunded);
        require(shares[msg.sender] == 0);
        uint256 balance = address(this).balance;
        
        if(balance >= total) {
            isFunded = true;
            uint256 overshot = balance.sub(total);
            msg.sender.transfer(overshot);
            shares[msg.sender] = msg.value.sub(overshot);
        } else {
           shares[msg.sender] = msg.value; 
        }
        totalShares += shares[msg.sender];
        shareHolders.push(msg.sender);
    }
    
    function transfer(address payable _receiver, uint256 _amount) public {
        require(msg.sender == owner);
        require(_amount <= address(this).balance);
        require(isFunded);
        _receiver.transfer(_amount);
    }
    
    function addIncome() public payable {
        for(uint256 i = 0; i < shareHolders.length; i++) {
            // Get percentage
            
            // This way won't work
            // uint256 sharePercentage = shares[shareHolders[i]].div(totalShares).mul(msg.value);
            
            // We have to multiply before dividing
            uint256 sharePercentage = shares[shareHolders[i]].mul(msg.value).div(totalShares);
            
            // Transfer
            shareHolders[i].transfer(sharePercentage);
        }
    }
}
