contract InvestmentOpportunity {
    address public investor;
    uint256 public payday;
    
    constructor() public payable {}
    function invest() external payable {
        require(investor == address(0), "Someone beat you to it!");
        require(msg.value == address(this).balance / 2,
            "You must match the contract balance.");
            
        investor = msg.sender;
        payday = now + 24 hours;
    }
    
    function withdraw() external {
        require(msg.sender == investor,
            "Only the investor can withdraw.");
        require(now >= payday,
            "You must wait until the payday time.");        
        msg.sender.transfer(address(this).balance);
    }
}
