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

    mapping (uint => Auctioner) listJoin;
    mapping (string => uint) checkItem;
    mapping (uint => uint) checkJoin;
    mapping (uint => uint) time;
    mapping (string => uint) public count;
    mapping (uint => uint[]) check;

    bidItem []items;

    event joiner (uint password, address account);
    event item (string name, uint value);
    event result (uint winner, string nameOfItem);

    constructor() {
        count["limit joiner"] = 5;
        count["limit item"] = 5;
        count["id item"] = 0;
    }

    function addItem(string memory nameOfItem, uint value) public {
        require(count["limit item"] != 0, "had enough item");
        if(items.length < 6){
            items.push(bidItem(nameOfItem, value));
            checkItem[nameOfItem] = 1;
            count["limit item"] --; 
            emit item (nameOfItem, value);
        }
    }

    function joinAuction(address addressUser,string memory name, uint password) public {
        require(count["limit joiner"] != 0, "had enough joiner");
        
        //return band.getElementOfArray(password);
        require(count["limit item"] == 0, "cannot join auction yet");
        require(listJoin[password].indentificationNumber == 0 ,"this account cannot join auction");
        band.addUser(addressUser, name, 0);
        require(band.getId(password) == 1, "wrong element");
        string [] memory emptyArray = new string[](0);
        uint code = createCode(createCode((password))) / 1e13;
        listJoin[code] = Auctioner(code, emptyArray);
        count["limit joiner"] --;
        if(count["limit joiner"] == 0){
            count["time access"] = block.timestamp;
            count["time stop"] = count["time access"];
        }
        //sendEther();
        emit joiner(code, addressUser);
    }

    // function show(address addressUser,string memory name,uint balance, uint password) public returns(uint) {
    //     band.addUser(addressUser, name, balance);
    //     return band.getBalance(id);
    // }

    function bid (string memory yourChoose, uint yourId) public{
        require(count["limit joiner"] == 0, "cannot bid yet");
        require(listJoin[yourId].indentificationNumber == yourId, "this id is not available");
        uint money = stringToUint(yourChoose);        
        
        //require(money >= items[idItem].startValue && money > best, "this account cannot auction");
        if(money == 0 ){
            checkJoin[yourId] = 1;
            check[1].push(yourId);
            //revert("you skipped");
        }
        //require(money > items[idItem].startValue, "your choose is not available");
        //require(checkJoin[yourId] == 0, "skiped cannot bid");
        if(money > items[count["id item"]].startValue && checkJoin[yourId] == 0 &&
        block.timestamp >= time[yourId] + 10 seconds){
            count["best id"] = yourId;
            items[count["id item"]].startValue = money;
            for(uint i = 0; i < check[i].length; i++){
                delete checkJoin[check[1][i]];
            }
        }
                
        time[yourId] = block.timestamp;
        if(count["time access"] + 1 minutes <= block.timestamp){
            listJoin[count["best id"]].item.push(items[count["id item"]].nameItem); 
            count["time access"] = block.timestamp;
            count["id item"] ++;
            emit result(count["best id"], items[count["id item"]].nameItem);
        }
        
        if(block.timestamp >= count["time stop"] + 5 minutes){
            count["limit joiner"] = 5;
            count["limit item"] = 5;
            count["id item"] = 0;
        }
    } 

    function show(uint code) public view returns(string[] memory){
        return listJoin[code].item;
    }

}
//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//1000
//4925571748283563