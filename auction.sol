pragma solidity >=0.6.12 <0.9.0;

import "band.sol";
import "start.sol";

contract Auction is Code{
    Band band = new Band();

    struct Auctioner {
        uint indentificationNumber;
        string [] item;
    }

    struct bidItem {
        string nameItem;
        uint startValue;
    }

    uint number = 0;
    uint indexItem = 1;
    uint limitJoiner = 1;
    uint limitItem = 2;
    uint best = 0;
    uint idJoiner = 0;
    uint idItem = 0;
    uint bestId = 0;
    uint timeAccess = 0;

    mapping (uint => Auctioner) listJoin;
    mapping (string => uint) checkItem;
    mapping (uint => bidItem) listItem;
    mapping (uint => uint) checkJoin;
    mapping (uint => uint) time;

    bidItem []items;
    uint []delListJoin;
    string []delCheckItem;
    uint []delListItem;
    uint []delCheckJoin;
    uint []delTime;

    event joiner (uint password, address account);
    event item (string name, uint value);

    function auctionEnd() private{
        // uint []delListJoin;
        // string []delCheckItem;
        // uint []delListItem;
        // uint []delCheckJoin;
        // string []delTime;

        for(uint i = 0; i < delListJoin.length; i ++){
            delete listJoin[delListJoin[i]];
        }
        for(uint i = 0; i < delCheckItem.length; i ++){
            delete checkItem[delCheckItem[i]];
        }
        for(uint i = 0; i < delListItem.length; i ++){
            delete listItem[delListItem[i]];
        }
        for(uint i = 0; i < delCheckJoin.length; i ++){
            delete checkJoin[delCheckJoin[i]];
        }
        for(uint i = 0; i < delTime.length; i ++){
            delete time[delTime[i]];
        }

        delete items;
        for(uint i = 0; i < delListJoin.length; i ++){
            delete delListJoin[i];
        }
        for(uint i = 0; i < delCheckItem.length; i ++){
            delete delCheckItem[i];
        }
        for(uint i = 0; i < delListItem.length; i ++){
            delete delListItem[i];
        }
        for(uint i = 0; i < delCheckJoin.length; i ++){
            delete delCheckJoin[i];
        }
        for(uint i = 0; i < delTime.length; i ++){
            delete delTime[i];
        }
        number = 0;
        limitJoiner = 1;
        limitItem = 2;
        best = 0;
        idJoiner = 0;
        idItem = 0;
        indexItem = 1;
        timeAccess = 0;
        
    }

    function joinAuction(address addressUser,string memory name, uint password) external payable {
        require(limitJoiner != 0, "had enough joiner");
        if(address(this).balance < 1 ether){
            revert();
        }
        //return band.getElementOfArray(password);
        require(limitItem == 0, "cannot join auction yet");
        require(listJoin[password].indentificationNumber == 0 ,"this account cannot join auction");
        band.addUser(addressUser, name, 0);
        require(band.getId(password) == 1, "wrong element");
        string [] memory emptyArray = new string[](0);
        uint code = createCode(number) / 1e13;
        listJoin[code] = Auctioner(code, emptyArray);
        delListJoin.push(code);
        number ++; limitJoiner --;
        if(limitJoiner == 0){
            timeAccess = block.timestamp;
        }
        sendEther();
        emit joiner(code, addressUser);
    }

    function addItem(string memory nameOfItem, uint value) public {
        require(limitItem != 0, "had enough auction item");
        require(checkItem[nameOfItem] == 0, "had");
        listItem[indexItem] = bidItem(nameOfItem, value);
        checkItem[nameOfItem] = 1;
        delListItem.push(indexItem);
        delCheckItem.push(nameOfItem);
        limitItem --; indexItem ++;
        emit item (nameOfItem, value);
    }

    // function show(address addressUser,string memory name,uint balance, uint password) public returns(uint) {
    //     band.addUser(addressUser, name, balance);
    //     return band.getBalance(id);
    // }

    function bid (string memory yourChoose, uint yourId) public{
        if(block.timestamp >= timeAccess + 5 minutes){
            auctionEnd();
            //return limitJoiner;
        }
        //require(listJoin[yourId].indentificationNumber == yourId, "this id is not available");
        require(block.timestamp >= time[yourId] + 10 seconds || time[yourId] == 0, "this joiner cannot bid yet");
        require(limitJoiner == 0, "cannot bid yet");
        if(idJoiner == 1)idJoiner = 0;
        uint money = stringToUint(yourChoose);
        if(money == 0){
            checkJoin[idJoiner] = 1;
            delCheckJoin.push(idJoiner);
        }
        
        idJoiner ++;
        require(money >= items[idItem].startValue && money > best, "your choose is not available");
        require(checkJoin[idJoiner] == 0, "skiped cannot bid");
        
        bestId = yourId;
        best = money;
        time[yourId] = block.timestamp;
        delTime.push(yourId);
        if(timeAccess + idItem + 1 minutes <= block.timestamp){
            listJoin[bestId].item.push(items[idItem].nameItem); 
            idItem ++;
        }
    } 

}
//9863699543627742