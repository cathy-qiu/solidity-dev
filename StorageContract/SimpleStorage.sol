// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;

// deploying a smart contract!

contract SimpleStorage { //define contract - like class in oop
    // this will get initialized to 0
    uint256 number;

    struct People { // making an object People
        uint256 num;
        string name;
    }

    People[] public people;
    mapping(string => uint256) public getFavNum;

    function store(uint256 _favNum) public {
        number = _favNum;
    }

    function retrieve() public view returns (uint256) {
        return number;
    }

    function addPerson(string memory _name, uint256 _num) public {
        people.push(People(_num, _name));
        getFavNum[_name] = _num;
    }
}