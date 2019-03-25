contract MappingIterator {
   mapping(string => address) elements;
   string[] keys;
   function put(string key, address addr) returns (bool) {
      bool exists = elements[key] != address(0)
      if (!exists) {
         keys.push(key);
      }
      elements[key] = addr;
      return true;
    }
    function getKeyCount() constant returns (uint) {
       return keys.length;
    }
    function getElementAtIndex(uint index) returns (address) {
       return elements[keys[index]];
    }
    function getElement(string name) returns (address) {
       return elements[name];
    }
}
