pragma solidity 0.4.19;


contract Fibonacci {
    /* Carry out calculations to find the nth Fibonacci number */
    function fibRecur(uint n) public pure returns (uint) {
    	if (n == 0) return 0;
        else if (n == 1) return 1;
        else return Fibonacci.fibonacci(n - 1) + Fibonacci.fibonacci(n - 2);
    }

    /* Carry out calculations to find the nth Fibonacci number */
    function fibIter(uint n) public returns (uint) {
    	uint last_1 = 0;
        uint last_2 = 1;
        uint save = 1;
        
        for(uint i;i<n-1;i++) {
            save = last_1 + last_2;
            last_1 = last_2;
            last_2 = save;
        }
        return save;
    }
}
