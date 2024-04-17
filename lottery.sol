// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract lottery{
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor(){
        manager=msg.sender;
    }
    function participate() public payable{
        require(msg.value==10 wei,"pay 1 ether");
        players.push(payable(msg.sender));
    }
    function getBalance() public view returns(uint){
        require(manager==msg.sender,"only the manager can access");
        return address(this).balance;
    }
    function random() internal view returns(uint){
         return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));

    }
    function pickWinner() public{
      require(manager==msg.sender,"only manager can access");
      require(players.length>=3,"there should be atleast 3 players");
      uint r=random();
      uint index = r%players.length;
      winner=players[index];
      winner.transfer(getBalance());
      players= new address payable[](0); 
    }
}