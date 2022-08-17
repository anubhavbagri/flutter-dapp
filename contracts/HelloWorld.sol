// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract HelloWorld {
    string public message;

    // executes for the first time when the contract is created
    constructor() {
        message = "Hello, World!";
    }

    function setMessage(string memory _message) public {
        message = _message;
    }
}
