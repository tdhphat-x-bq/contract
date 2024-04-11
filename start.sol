pragma solidity >=0.6.12 <0.9.0;

contract Code {
    function createCode(uint myCode) internal returns(uint) {
        uint pass = uint(keccak256(abi.encodePacked(myCode)));
        return pass % 1e16;
    } 
    address payable owner;
    event failure (string typeFail);

    constructor() {
        owner = payable(msg.sender); // Thiết lập chủ sở hữu là người tạo hợp đồng
    }

    function sendEther() internal {
        //require(msg.sender == owner, "Only the contract owner can withdraw");
        //owner.transfer(1 ether);
        (bool sent, bytes memory data) = owner.call{value: 1 ether}("");
        require(sent, "Failed to send ether");
    }

    function stringToUint(string memory s) internal  returns (uint) {
        bytes memory b = bytes(s);
        uint result = 0;
        for (uint i = 0; i < b.length; i++) { // c = b[i] was not needed
            if (uint8(b[i]) >= 48 && uint8(b[i]) <= 57) {
                result = result * 10 + (uint8(b[i]) - 48); // bytes and int are not compatible with the operator -.
            }
        }
        return result; // this was missing
    }
    
}