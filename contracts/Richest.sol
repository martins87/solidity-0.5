pragma solidity ^0.5.7;

contract Richest {
    address payable public richest;
    uint public mostSent;

    constructor() public payable {
        richest = msg.sender;
        mostSent = msg.value;
    }

    function becomeRichest() public payable returns (bool) {
        if (msg.value > mostSent) {
            richest.transfer(msg.value);
            richest = msg.sender;
            mostSent = msg.value;
            return true;
        } else {
            return false;
        }
    }
    
    function getBalance() public view returns (uint) {
        return msg.sender.balance;
    }
    
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
    
}
