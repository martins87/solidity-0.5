pragma solidity ^0.5.2;

contract StringMemory {
    
    Person[] people;
    
    uint public peopleCount;
    
    struct Person {
        string firstName;
        string lastName;
    }
    
    function getPerson(uint _i) public view returns (string memory, string memory){
        require(_i < peopleCount);
        return (people[_i].firstName, people[_i].lastName);
    }
    
    function addPeople(string memory _firstName, string memory _lastName) public {
        people.push(Person(_firstName, _lastName));
        peopleCount++;
    }
    
}
