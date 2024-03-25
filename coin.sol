pragma solidity >=0.6.12 <0.9.0;

import "contracts/inheritance.sol";

contract coin is Inheritance{

   struct user{
        address addr;
        string name;
        uint password;
        uint balance;
   }

    struct Recharge{
        uint money;
        address addr;
    }

    mapping (address => user) users;
    mapping (string => uint) checkName;
    mapping (uint => Recharge) recharges;
    mapping (uint => uint) transacted;
    mapping (address => uint) shows;
    mapping (address => uint) timeToTransfer;
    mapping (address => uint) timeToRecharge;

    event User(address from, address to, uint balance);
    event recharged(address ar, uint money);
    event traded(address addUser, string name, uint money);
    event add(address ar, string name, uint balance);

    modifier login(address from,string memory name,uint password){
        uint new_name1 = uint(keccak256(abi.encodePacked(users[from].name)));
        uint new_name2 = uint(keccak256(abi.encodePacked(name)));
        require(users[from].addr == from && new_name1 == new_name2 && users[from].password == password,
        "your information is not exist");
        _;
    }

    function transfer(address from,string memory name,uint password,address to,uint money)public
    login(from,name,password) {
        require(users[to].addr == to, "this address is not exist");
        require(timeToTransfer[from] == 0 || block.timestamp >= timeToTransfer[from] + 20 seconds, "not yet deploy");
        timeToTransfer[from] = block.timestamp;
        require(from != to, "email of receiver is not available");
        require(money <= users[from].balance,"ngheo bay dat chuyen tien");
        
        users[from].balance -= money;
        users[to].balance += money;

        emit User(from, to, money);
    }

    function transaction(address addUser, string memory name, uint money, uint password)public 
    login(addUser, name, password) {
        require((timeToRecharge[addUser] == 0 || timeToRecharge[addUser] + 20 seconds <= block.timestamp), "not yet deploy");
        timeToRecharge[addUser] = block.timestamp;

        uint codeRecharge = createCodeRecharge(password);

        transacted[codeRecharge] = 1;
        recharges[codeRecharge] =  Recharge(money, addUser);
        shows[addUser] = codeRecharge;
        emit traded(addUser, name, money);
    }

    function recharge(uint codeRecharge)public {
        require(transacted[codeRecharge] == 1,"not yet traded");
        address addressRecharge = recharges[codeRecharge].addr;

        users[addressRecharge].balance += recharges[codeRecharge].money;
        
        emit recharged(addressRecharge, recharges[codeRecharge].money);
    }

    function showCode(address ar) public returns(uint){
        return shows[ar];
    }

    function createPassword(string memory name) private returns(uint){
        uint password = uint(keccak256(abi.encodePacked(name)));
        return password % 1e16;
    }

    function addUser(address addressUser,string memory name,uint balance)public {
        require(users[addressUser].addr == address(0) && checkName [name] != 1,"Adress already exists");
        // require(users[addressUser].addr == address(0),"wrong address");
        // require(checkName [name] != 1, "wrong name");
        checkName [name] = 1;
        uint password = createPassword(name);
        users[addressUser] = user(addressUser, name, password, balance);
        emit add(addressUser, name, balance);
    }

    function showAccount(address addressUser) public returns (address addr, string memory, uint, uint){
        user memory u = users [addressUser];
        return (u.addr, u.name, u.password, u.balance);
    }

}
//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//1000
//4925571748283563
//3049476452354007
//0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//123
//6371183830765904
//1102003695344237
