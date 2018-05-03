pragma solidity ^0.4.23;

contract Gambling {
	// Our code goes here
	address public playerOne;
	address public playerTwo;

	bool public playerOnePlayed;
	bool public playerTwoPlayed;

	uint private playerOneDeposit;
	uint private playerTwoDeposit;

	bool public gameFinished;
	address public theWinner;
	uint gains;

	event GamblingStarts(address playerOne, address playerTwo);
	event GamblingEnds(address winner, uint gains);

	function Constructor() public{
		playerOne = msg.sender;
	}

	function registerAsAnOpponent() public{
		require(playerTwo == address(0));

		playerTwo = msg.sender;

		emit GamblingStarts(playerOne, playerTwo);
	}

	function gamble() public payable{
		require(!gameFinished && (msg.sender == playerOne || msg.sender == playerTwo));
		
		if(msg.sender == playerOne){
			require(!playerOnePlayed);
			playerOnePlayed = true;
			playerOneDeposit = msg.value;
		} else {
			require(!playerTwoPlayed);
			playerTwoPlayed = true;
			playerTwoDeposit = msg.value;
		}

		if(playerOnePlayed && playerTwoPlayed){
			if(playerOneDeposit >= playerTwoDeposit){
				endOfGame(playerOne);
			} else {
				endOfGame(playerTwo);
			}
		}		
	}

	function endOfGame(address winner) private {
		gameFinished = true;
		theWinner = winner;
		gains = playerOneDeposit + playerTwoDeposit;
		emit GamblingEnds(winner, gains);
	}

	function withdraw() public{
		require(gameFinished && theWinner == msg.sender);

		uint amount = gains;

		gains = 0;
		msg.sender.transfer(amount);
	}

}