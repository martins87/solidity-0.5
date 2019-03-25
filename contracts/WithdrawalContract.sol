contract WithdrawalContract {
   mapping(address => uint) buyers;
   function buy() payable {
      require(msg.value > 0);
      buyers[msg.sender] = msg.value;
   }
   function withdraw() {
      uint amount = buyers[msg.sender];
      require(amount > 0);
      buyers[msg.sender] = 0;      
      require(msg.sender.send(amount));
   }
}
