pragma solidity ^0.4.19;


contract Betting {
    
    /* Standard state variables */
    address public owner;
    address public gamblerA;
    address public gamblerB;
    address public oracle;
    
    /* Keep track of every gambler's bet */
    mapping (address => Bet) bets;
    /* Keep track of every player's winnings (if any) */
    mapping (address => uint) winnings;
    /* Keep track of all outcomes (maps index to numerical outcome) */
    mapping (uint => uint) public outcomes;
    
    /* 0 if false, 1 if true */
    mapping (address => bool) public hasBetted;
    
    uint numOutcomes;
    
    /* Constructor function, where owner and outcomes are set */
    function Betting(uint[] _outcomes) public {
        numOutcomes = 1;
        for (uint i = 0; i < _outcomes.length; i++) {
            numOutcomes++;
            outcomes[i] = _outcomes[i];
        }

    }
    
    /* Fallback function */
    function() public payable {
        revert();
    }

    /* Structs are custom data structures with self-defined parameters */
    struct Bet {
        uint outcome;
        uint amount;
        bool initialized;
    }
    
    /* Add any events you think are necessary */
    event BetMade(address gambler);
    event BetClosed();

    /* Uh Oh, what are these? */
    modifier ownerOnly() {_;}
    modifier oracleOnly() {_;}
    modifier outcomeExists(uint outcome) {_;}

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() returns (address) {
        oracle = _oracle;
        return oracle;
    }
    
    uint numBetters;
    address[] betters;
    
    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome, uint _amount) public payable returns (bool) {
        /* JAZZ: CALL CHECKOUTCOMES HERE. */
        if (msg.sender != owner && hasBetted[msg.sender] == false && numBetters < 2) {
             bets[msg.sender] = Bet(_outcome, _amount, true);
             hasBetted[msg.sender] = true;
             betters[numBetters] = msg.sender;
             numBetters++;
             msg.balance -= _amount;
             return true;
        }
        
        return false;
    }
    
    
    
    /* The oracle chooses which outcome wins */
    function makeDecision() public oracleOnly() {
        uint winningOutcome = outcomes[randomGen()];
        Bet firstBet = bets[betters[0]];
        Bet secondBet = bets[betters[1]];
        if (firstBet.outcome == secondBet.outcome) {
            betters[0].balance += firstBet.amount;
            betters[1].balance += secondBet.amount;
        } else if (firstBet.outcome != winningOutcome && secondBet.outcome != winningOutcome) {
            winnings[oracle] += (firstBet.amount + secondBet.amount);
        } else if (firstBet.outcome == winningOutcome) {
            winnings[betters[0]] += (firstBet.amount + secondBet.amount);
        } else if (secondBet.outcome == winningOutcome) {
            winnings[betters[1]] += (firstBet.amount + secondBet.amount);
        }
    }
    
    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
        if (winnings[msg.sender] > 0) {
            msg.sender.balance += winnings[msg.sender];
        }
    }
    
    /* From https://gist.github.com/alexvandesande/259b4ffb581493ec0a1c */
    function randomGen() constant returns (uint randomNumber) {
        return(uint(sha3(block.blockhash(block.number-1), 5 ))%numOutcomes);
    }
    
    /* Allow anyone to check the outcomes they can bet on */
    function checkOutcomes(uint outcome) public view returns (uint) {
        return outcomes;
    }
    
    /* Allow anyone to check if they won any bets */
    function checkWinnings() public view returns(uint) {
        return winnings[msg.sender] > 0;
    }

    /* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
    function contractReset() public ownerOnly() {

        delete gamblerA;
        delete gamblerB;
        delete oracle;
        
        delete bets;
        delete winnings;
        delete outcomes;
        
        delete hasBetted;
        
        delete numOutcomes;
        
        delete numBetters;
        delete betters;
    
    }

    
}