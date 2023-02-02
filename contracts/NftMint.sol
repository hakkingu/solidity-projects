// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMinter is ERC721, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_TOKENS = 1000;
    uint256 private constant TOKENS_RESERVED = 5;
    uint256 public price = 80000000000000000;
    uint256 public constant MAX_MINT = 10;

    bool public isSaleActive;
    uint256 public totalSupply;
    mapping(address => uint256) private mintedPerWallet;

    string public baseUri;
    string public baseExtension = ".json";

    constructor() ERC721("NFT Name", "Symbol") {
        baseUri = "ipfs://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/";
        for (uint256 i = 1; i <= TOKENS_RESERVED; ++i) {
            _safeMint(msg.sender, i);
        }
        totalSupply = TOKENS_RESERVED;
    }

    function NFTMinting(uint256 _numTokens) external payable {
        require(isSaleActive, "The sale is paused");
        require(
            _numTokens <= MAX_MINT,
            "You can only mint 10 NFTS per transaction."
        );
        require(
            mintedPerWallet[msg.sender] + _numTokens <= 10,
            "Sorry, you can only mint 10 tokens per wallet."
        );
        uint256 curTotalSupply = totalSupply;
        require(
            curTotalSupply + _numTokens <= MAX_TOKENS,
            "It exceeds 'MAX_TOKENS'."
        );
        require(
            _numTokens * price <= msg.value,
            "Insufficient funds. You must Buy more eth~"
        );

        for (uint256 i = 1; i <= _numTokens; ++i) {
            _safeMint(msg.sender, curTotalSupply + i);
        }
        mintedPerWallet[msg.sender] += _numTokens;
        totalSupply += _numTokens;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function flipSaleState() external onlyOwner {
        isSaleActive = !isSaleActive;
    }

    function setBaseUri(string memory _baseUri) external onlyOwner {
        baseUri = _baseUri;
    }

    function withdraw() external payable onlyOwner {
        uint256 balance = address(this).balance;
        uint256 balanceOne = (balance * 70) / 100;
        uint256 balanceTwo = (balance * 30) / 100;
        (bool transferOne, ) = payable(
            0x90431ce68aCb099eB441f723a084B0F0670Fa97A
        ).call{value: balanceOne}("");
        (bool transferTwo, ) = payable(
            0x5606c574c4a0a6294c13F1EebC16a22aD145D850
        ).call{value: balanceTwo}("");
        require(transferOne && transferTwo, "Transfer failed.");
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseUri;
    }
}
