// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 < 0.9.0;

contract SolVoting {
    mapping (string => uint256) public votesReceived;
 
    string [] public candidateSolList;
    
 
    constructor (string [] memory candidateUsernames) {
        candidateSolList = candidateUsernames;

    }

function totalVotes(string memory candidate) view public returns (uint256) {
    require (validCandidate(candidate));
    return votesReceived[candidate];
}

function voteFor(string memory candidate) public {
    require(validCandidate(candidate));
    votesReceived[candidate] +=1;
}

function validCandidate (string memory candidate) view public returns(bool) {
    for (uint i = 0; i < candidateSolList.length; i++) {
        if(keccak256(abi.encodePacked(candidateSolList[i])) == keccak256(abi.encodePacked(candidate))) {
            return true;
        }
    }
return false;
}

}
