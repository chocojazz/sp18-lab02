pragma solidity 0.4.19;


contract XOR {
    function xor(uint a, uint b) public pure returns (uint) {
    	bool bool_1 = false;
        bool bool_2 = false;
        byte one = '1';
        
        if (a == one){
            bool_1 = true;
        }

        if (b == one){
            bool_2 = true;
        }

        if (exclusveOr(bool_1, bool_2) == true) {
        	return 1;
        }
        return 0;
    }

    function  exclusiveOr(bool bool_1, bool bool_2) private returns(bool result) {
        return (bool_1 || bool_2) && !(bool_1 &&  bool_2);
    }
}
