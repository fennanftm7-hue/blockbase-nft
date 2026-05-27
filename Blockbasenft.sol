// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BlockBaseNFT is ERC721 {
    address public owner;
    uint256 public mintPrice = 0.001 ether;
    uint256 public nextTokenId;
    
    // EXTENSION: Maximum supply cap configuration
    uint256 public constant MAX_SUPPLY = 50;

    struct TokenData {
        string name;
        address tokenOwner;
        uint256 mintedAt;
    }

    mapping(uint256 => TokenData) private _tokenData;
    mapping(address => uint256[]) private _ownedTokens;

    event Minted(address indexed to, uint256 indexed tokenId, string name);
    event MintPriceChanged(uint256 oldPrice, uint256 newPrice);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    constructor() ERC721("BlockBase Collection", "BNFT") {
        owner = msg.sender;
    }

    function mint(string memory name) external payable {
        require(bytes(name).length > 0, "Name cannot be empty");
        // EXTENSION: Reject mint if maximum supply cap is reached
        require(nextTokenId < MAX_SUPPLY, "Max supply reached");
        require(msg.value >= mintPrice, "Insufficient ETH sent");

        uint256 tokenId = nextTokenId;
        nextTokenId++;

        _tokenData[tokenId] = TokenData({
            name: name,
            tokenOwner: msg.sender,
            mintedAt: block.timestamp
        });

        _ownedTokens[msg.sender].push(tokenId);
        _safeMint(msg.sender, tokenId);

        emit Minted(msg.sender, tokenId, name);

        if (msg.value > mintPrice) {
            uint256 refundAmount = msg.value - mintPrice;
            (bool refundSuccess, ) = msg.sender.call{value: refundAmount}("");
            require(refundSuccess, "Refund execution failed");
        }
    }

    function setMintPrice(uint256 newPrice) external onlyOwner {
        emit MintPriceChanged(mintPrice, newPrice);
        mintPrice = newPrice;
    }

    function withdraw() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds to withdraw");
        (bool success, ) = owner.call{value: contractBalance}("");
        require(success, "Withdraw execution failed");
    }

    function getOwnedTokens(address tokenOwner) external view returns (uint256[] memory) {
        return _ownedTokens[tokenOwner];
    }

    function getTokenData(uint256 tokenId) external view returns (
        string memory name, 
        address tokenOwner, 
        uint256 mintedAt
    ) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        TokenData memory data = _tokenData[tokenId];
        return (data.name, data.tokenOwner, data.mintedAt);
    }
}