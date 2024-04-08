pragma solidity >=0.6.12 <0.9.0;

import "start.sol";

contract Band is Code{
    //Code code = new Code();
    struct user{
        address addr;
        uint password;
        uint balance;
        uint codeRecharge;
   }

    struct Recharge{
        uint money;
        uint password;
    }

    mapping (uint => user) users;
    mapping (address => user) otherUsers;
    mapping (uint => Recharge) recharges;
    mapping (uint => uint) transacted;
    mapping (address => uint) timeToActive;
    mapping (address => uint) checkAdress;
    uint [1e30] array;

    event User(string nameActive, address from, address to, uint balance);
    event recharged(string nameActive, address ar, uint money);
    event traded(string nameActive, address ar, uint money, uint code);
    event add(string nameActive, address ar, string name, uint balance, uint password);

    modifier login(uint password){
        require(users[password].password == password, "your information is not exist");
        require(block.timestamp >= timeToActive[users[password].addr] + 20 seconds, "can't deploy please wait");

        timeToActive[users[password].addr] = block.timestamp;
        _;
    }

    function addUser(address addressUser,string memory name,uint balance)public {
        if(checkAdress[addressUser] == 0){
            uint password = uint(keccak256(abi.encodePacked(name)))%1e16;
            checkAdress[addressUser] = 1;
            users[password] = user(addressUser, password, balance, password);
            otherUsers[addressUser] = user(addressUser, password, balance, password);
            array[password] = 1;
            emit add("sign up", addressUser, name, balance, password);
        }
    }

    function getId(uint index) public returns(uint) {
        return array[index];
    }

    function transfer(uint password,address to,uint money)external payable login(password){
        require(checkAdress[to] == 1 && users[password].addr != to, "this address is not available");
     
        uint ethereum = address(this).balance;
        if(ethereum < 1 ether){
            revert();
        }
        require(money <= users[password].balance,"ngheo bay dat chuyen tien");
        
        users[password].balance -= money;
        uint new_pass = otherUsers[to].password;
        users[new_pass].balance += money;
        
        sendEther();

        emit User("transfer", users[password].addr, to, money);
    }

    function transaction(uint money, uint password)external  payable login(password){
        uint ethereum = address(this).balance;
        if(ethereum < 1 ether){
            revert();
        }
        uint codeRecharge = createCode(password);

        users[password].codeRecharge = codeRecharge;

        transacted[codeRecharge] ++;
        recharges[codeRecharge] =  Recharge(money, password);
        sendEther();
        emit traded("transaction", users[password].addr, money, codeRecharge);
    }

    function recharge(uint codeRecharge)public {
        require(transacted[codeRecharge] != 0,"this card not yet traded");
        uint code = recharges[codeRecharge].password;

        transacted[codeRecharge] --;
        users[code].balance += recharges[codeRecharge].money;

        emit recharged("recharge", users[code].addr, recharges[codeRecharge].money);
    }
    
}
//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//1000
//4925571748283563
//1448220239837877
//0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//123
//9858819262702947
//1102003695344237
//7989623269508935
//9863699543627742