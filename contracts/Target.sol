pragma solidity ^0.5.0;

contract Target {
    
    mapping (address => uint) balances;
    
    function deposit() public payable {
        require((balances[msg.sender] + msg.value) >= balances[msg.sender]);
        balances[msg.sender] += msg.value;
    }
    
    function withdraw(uint amount) public {
        require(balances[msg.sender] >= amount);
        msg.sender.call.value(amount)("");
        
        balances[msg.sender] -= amount;
    }
    
}
