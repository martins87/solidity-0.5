pragma solidity 0.5.1;

import "./SafeMath.sol";

contract RealEstateToken {
    using SafeMath for uint256;
    
    /*
    - one Smart Contract for all properties
    - every property can have its own tokens
    - the contract owner can create properties
    - for each property created, the CEO decides how many tokens
    */
    address owner;
    
    // "ERC-721" + "ERC-20"
    mapping(uint256 => mapping(address => uint256)) propertiesShares;
    
    uint256 private properties;
    
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
        propertiesShares[properties][owner] = _totalShares;
    }
    
    function sharesOf(uint property) public view returns(uint){
        require(property > 0 && property <= properties, "Invalid property");
        return propertiesShares[property][msg.sender];
    }
    
    function sharesOfAddress(uint property, address _address) public view returns(uint){
        require(property > 0 && property <= properties, "Invalid property");
        return propertiesShares[property][_address];
    }
    
    function transfer(uint256 property, address recipient, uint256 amount) public returns(bool) {
        require(propertiesShares[properties][owner] >= amount, "Insufficient funds");
        require(recipient != address(0), "Transfer to the zero address");
        
        propertiesShares[property][owner] = propertiesShares[property][owner].sub(amount);
        propertiesShares[property][recipient] = propertiesShares[property][recipient].add(amount);
        
        return true;
    }
    
    /*
    function buyShares(uint256 property) public payable reteurns(bool) {
        transfer();
    }*/
    
}
