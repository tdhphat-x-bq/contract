pragma solidity >=0.6.12 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Inheritance{

    function createCodeRecharge(uint code) internal  returns (uint){
        string memory str = Strings.toString(code);
        uint c = uint(keccak256(abi.encodePacked(str)));
        return c % 1e16;
    }

}