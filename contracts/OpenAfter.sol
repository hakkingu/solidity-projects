//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.16;

contract OpenAfter {
    mapping(uint256 => Person) public people;
    uint256 peoplecount = 0;
    uint256 timer = 1674940706;

    modifier onlyIfItsOpen() {
        require(block.timestamp >= timer);
        _;
    }

    struct Person {
        uint256 peoplecount;
        string name;
        uint256 age;
    }

    function addPerson(string memory name, uint256 age) public onlyIfItsOpen {
        increment();
        people[peoplecount] = Person(peoplecount, name, age);
    }

    function increment() internal {
        peoplecount += 1;
    }
}
