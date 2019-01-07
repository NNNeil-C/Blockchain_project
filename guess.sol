pragma solidity ^0.5.0;

contract Game
{
    struct Player {
        uint amount;
        uint number;
        bool isStart;
        bool isInit;
        string msgg;
    }

    mapping (address => Player) players;
    uint nonce;
    uint lucky;
    uint cost = 300;

    constructor () public {
    	nonce = 0;
    }

    function init () public {
    	if (players[msg.sender].isInit == false) {
    		players[msg.sender].isInit = true;
    		players[msg.sender].amount = 801;
    		players[msg.sender].isStart = false;
        players[msg.sender].msgg = "";
        players[msg.sender].number = 0;
        
    	}
    }

    function newGame () public {
    	if (!players[msg.sender].isInit) {
    		players[msg.sender].msgg = "Please start your game";
            return;
    	}

    	if (players[msg.sender].isStart) {
    		players[msg.sender].msgg = "Good luck and make your draw.";
            return;
    	}


    	if (cost > players[msg.sender].amount) {
    		players[msg.sender].msgg = "Not enough money.";
            return;
    	}

    	players[msg.sender].amount -= cost;
    	players[msg.sender].isStart = true;
    	players[msg.sender].number = 0;
    	players[msg.sender].msgg = "Game Start!";
      lucky = 0;
    	return;
    }

    function gambling (uint num) public {
    	if (!players[msg.sender].isStart) {
    		return;
    	}

      setNumber(num);

        uint random = uint(keccak256(abi.encode(now, msg.sender, nonce))) % 1000;
        nonce ++;
        lucky = random + 1;

        bonus(lucky);
    	Reset();
    	return;
    }

    function setNumber(uint num) private{
      players[msg.sender].number = num;
    }

    function bonus (uint luckyNumber) private {
        uint award = players[msg.sender].number - luckyNumber;
        if (award < 0) 
            award = -award;
        award = (1000 - award) / 3;
    	players[msg.sender].amount += award;
        
    }

    function Reset () private {
    	players[msg.sender].isStart = false;

    }


    function isInit () view public returns(bool res) {
    	res = players[msg.sender].isInit;
    }

    function isStart () view public returns(bool res) {
    	res = players[msg.sender].isStart;
    }

    function getAmount () view public returns(uint res) {
    	res = players[msg.sender].amount;
    }

    function getNumber () view public returns(uint res) {
    	res = players[msg.sender].number;
    }

    function getMsg () view public returns (string memory res) {
        res = players[msg.sender].msgg;
    }

    function getResult () view public returns (uint Result) {
        Result = lucky;
    }

}
