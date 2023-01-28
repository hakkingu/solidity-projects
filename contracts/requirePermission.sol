//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.16;

contract requirePermission {
    mapping(uint256 => Person) public people;
    uint256 peoplecount = 0;

    address owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    struct Person {
        uint256 peoplecount;
        string name;
        uint256 age;
    }

    function addPerson(string memory name, uint256 age) public onlyOwner {
        increment();
        people[peoplecount] = Person(peoplecount, name, age);
    }

    function increment() internal {
        peoplecount += 1;
    }
}
