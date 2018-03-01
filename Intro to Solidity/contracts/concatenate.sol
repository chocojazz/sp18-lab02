pragma solidity 0.4.19;


contract Concatenate {
    function concatWithoutImport(string _s, string _t) public returns (string) {
    	bytes memory _string_1 = bytes(_s);
        bytes memory _string_2 = bytes(_t);
        
        string memory new_string = new string(_string_1.length + _string_2.length);
        bytes memory _new_string = bytes(new_string);
        uint k = 0;
        for (uint i = 0; i < _string_1.length; i++) _new_string[k++] = _string_1[i];
        for (i = 0; i < _string_1.length; i++) _new_string[k++] = _string_2[i];

        return string(_new_string);
    }

    /* BONUS */
    function concatWithImport(string s, string t) public returns (string) {
    }
}
