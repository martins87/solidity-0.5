pragma solidity 0.5.1;

import "./SafeMath.sol";

contract RealEstateToken {
    using SafeMath for uint256;
    
    uint256 public remainder;
    
    /*
    - one Smart Contract for all properties
    - every property can have its own tokens
    - the contract owner can create properties
    - for each property created, the CEO decides how many tokens
    */
    address owner;
    
    // "ERC-721" + "ERC-20"
    mapping(uint256 => mapping(address => uint256)) propertiesShares;
    
    uint256 public properties;
    
    constructor() public {
        owner = msg.sender;
        properties = 3;
        propertiesShares[1][msg.sender] = 2500;
        propertiesShares[2][msg.sender] = 100;
        propertiesShares[3][msg.sender] = 5;
    }
    
    /**
     * @dev Allows the owner to create a property and define the amount of shares
     * @param _totalShares the amount of the new property shares 
     */
    function createProperty(uint _totalShares) public {
        require(msg.sender == owner);
        properties++;
        propertiesShares[properties][msg.sender] = _totalShares;
    }
    
    function sharesOf(uint property) public view returns(uint){
        require(property > 0 && property <= properties, "Invalid property");
        return propertiesShares[property][msg.sender];
    }
    
    function sharesOfAddress(uint property, address _address) public view returns(uint){
        require(property > 0 && property <= properties, "Invalid property");
        return propertiesShares[property][_address];
    }
    
    function transfer(uint256 property, address _recipient, uint256 amount) public returns(bool) {
        //require(propertiesShares[properties][msg.sender] >= amount, "Insufficient funds");
        require(_recipient != address(0), "Transfer to the zero address");
        
        remainder = propertiesShares[property][msg.sender] - amount;
        
        propertiesShares[property][msg.sender] -= amount;
        propertiesShares[property][_recipient] += amount;
        
        return true;
    }
    
    function burnShares(uint256 amount) public returns(bool) {
        propertiesShares[1][msg.sender] -= amount;
    }
    
}
