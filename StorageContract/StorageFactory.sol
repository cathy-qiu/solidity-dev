// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;

import "./SimpleStorage.sol";

// a way to interact with contracts from another contract (deploy contract using another contract)

contract StorageFactory {

    SimpleStorage[] public simpleStorageArray;

    function createContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 ssIndex, uint256 ssNum) public {
        SimpleStorage ss = SimpleStorage(address(simpleStorageArray[ssIndex]));
        ss.store(ssNum);
    }

    function sfRetrieve(uint256 ssIndex) public view returns (uint256){
        SimpleStorage ss = SimpleStorage(address(simpleStorageArray[ssIndex]));
        return ss.retrieve();
    }
}