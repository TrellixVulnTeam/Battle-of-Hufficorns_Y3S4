// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./verifier.sol";

contract Hufficorn is  ERC721URIStorage, Ownable, ReentrancyGuard{
    
    Verifier public verifier;
    string baseURI;
    uint256 tokenSupply;
    using Counters for Counters.Counter;

    Counters.Counter private tokenCount;

    address platform;

    struct NFTData {
        uint tokenId;
        string tokenURI;
        address tokenOwner;
    }

    NFTData[] nftData;
    mapping(address => uint) ownerMapping;
    mapping(address => NFTData) nftTokenMap;


    event Minted(address owner, uint numTokens);
    event Sold(uint tokenId, uint salePrice);
    event OwnershipGranted(address newOwner);

    modifier onlyTokenOwner(uint tokenId) {
        require(msg.sender == ownerOf(tokenId), "Only token owner can call this function");
        _;
    }

    constructor (
        string memory baseTokenURI
    ) ERC721("Hufficorn", "HUFF") {
        baseURI = baseTokenURI;
        platform = msg.sender;
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overriden in child contracts.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setTotalSupply( uint256 _totalSupply) public returns(uint256){
        tokenSupply = _totalSupply;
        return tokenSupply;
    }

    function totalSupply() public view returns(uint256) {
       return tokenSupply;
    }
    /*
        Mint Hufficorns.
        @dev: 
    */
    function mintHufficorn(string memory tokenMetadata) public {
        tokenCount.increment();
        uint256 tokenId = tokenCount.current();
        require(tokenId <= totalSupply(), "All the Hufficons have been minted");

        require(ownerMapping[msg.sender] == 0, "Owner has already minted");

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenMetadata);
            
        NFTData memory nft = NFTData(tokenId, tokenURI(tokenId), msg.sender);
        ownerMapping[msg.sender] = tokenId;
        nftTokenMap[msg.sender] = nft;
        nftData.push(nft);

        emit Minted(msg.sender, tokenId);
        
    }

    /* Get the total number of Hufficorns
    */
    function getTotalMintedHufficorn() external view returns(uint256) {
        return totalSupply();
    }

    /**
    * @dev Owner can transfer the ownership of the contract to a new account (`_grantedOwner`).
    * Can only be called by the current owner.
    */
    function grantContractOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "New owner cannot be zero address");
        _transferOwnership(newOwner);
        emit OwnershipGranted(newOwner);
    }

    /*
    */
    function getOwnerNft() public view returns(NFTData memory tokenMap) {
        return nftTokenMap[msg.sender];
    }

}

contract HufficornGame {

    using SafeMath for uint;

    Verifier public verifier;
    using Counters for Counters.Counter;
    Counters.Counter private gameIds;
    address _platform;

    struct Game {
        uint256 gameId;
        uint256 tokenId;
        uint256 attributeNum;
        uint256 creatorAttributeValue;
        address creator;
        uint256 poolMoney;
        bool active;
    }

    Game[] games;

    mapping(uint256 => address[]) gamePlayers;
    mapping(uint256 => uint256[]) attributePoints;
    mapping(uint256 => Game) gameMap;
    mapping(uint256 => bool) tokenInUse;
    mapping(uint256 => address[]) winnerList;
    mapping(uint256 => uint256[]) tokensPerGame;
    mapping(address => uint256) public userBalance;

    constructor(address platform) {
        _platform = platform;
    }

    function createGame(uint256 tokenId, uint256 attributeNum, uint256 attributeValue, uint256 amount) public payable returns(uint256) {
        gameIds.increment();
        uint256 gameId = gameIds.current();

        require(msg.value >= amount, "Not enough amount to create a game");
        require(tokenInUse[tokenId] == false, "Token ID is already used in another game");


        Game memory newGame = Game(gameId, tokenId, attributeNum, attributeValue, msg.sender, msg.value ,true);
        gameMap[gameId] = newGame;

        tokenInUse[tokenId] = true;

        gamePlayers[gameId].push(msg.sender);
        attributePoints[gameId].push(attributeValue);
        tokensPerGame[gameId].push(tokenId);
        games.push(newGame);

        return gameId;

    }


    function joinGame(uint256 gameId, uint256 tokenId, uint256 attributeValue,  uint256[2] memory a, uint256[2][2] memory b, uint256[2] memory c, uint256[4] memory _publicInputs) public payable returns(bool) {
        Game memory game = gameMap[gameId];
     
        require(msg.value >= game.poolMoney, "Not enough amount to join the game");
        require(game.active == true, "Game is not active anymore");
        require(tokenInUse[tokenId] == false, "Token ID is already used in another game");
        require(verifier.verifyProof(a, b, c, _publicInputs) == true, "Invalid attribute value");

        gamePlayers[gameId].push(msg.sender);
        attributePoints[gameId].push(attributeValue);
        tokenInUse[tokenId] = true;
        tokensPerGame[gameId].push(tokenId);
    
        return true;

    }

    function finishGame(uint256 gameId) public returns(bool) {

        uint256 totalPlayers = gamePlayers[gameId].length;
        Game memory currentGame = gameMap[gameId];

        require(currentGame.active == true, "Game is not active anymore");

        uint256 maxValue = currentGame.creatorAttributeValue;
        
        /*
        1. Finding out the maximum attribute value
        2. Changing the token in use status to false for all the participating tokens.
        */
        for(uint256 i = 0; i < totalPlayers; i++) {
            if(attributePoints[gameId][i] > maxValue){
                maxValue = attributePoints[gameId][i];
            }
            tokenInUse[tokensPerGame[gameId][i]] = false;
        }

        for(uint256 i = 0; i < totalPlayers; i++) {
            if(attributePoints[gameId][i] == maxValue) {
                winnerList[gameId].push(gamePlayers[gameId][i]);
            }
        }

        uint256 totalNumWinners =  winnerList[gameId].length;
        uint256 winningAmountPerWinner =  (totalPlayers)*(currentGame.poolMoney/(100*totalNumWinners))*(90);
        uint256 platformFee = (totalPlayers)*(currentGame.poolMoney/100)*(10);


        //Settlement for winners and platform - 10% fees to platform
        for(uint256 i = 0; i < totalNumWinners; i++){
            userBalance[winnerList[gameId][i]] = userBalance[winnerList[gameId][i]].add(winningAmountPerWinner);
            // payable(winnerList[gameId][i]).transfer(winningAmountPerWinner);
        }

        // payable(_platform).transfer(platformFee);

        currentGame.active == false;
        gameMap[gameId] = currentGame;

        return true;

    }

        function withdraw() public {
        require(userBalance[msg.sender] > 0, "No balance to withdraw");
        uint val = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        payable(address(uint160(msg.sender))).transfer(val);
    }

    function getAllGames() public view returns(Game[] memory) {
            return games;
    }

    function gameData(uint256 gameId) public view returns(Game memory) {
        return gameMap[gameId];
    }

    function contractBalance() public view returns(uint) {
        return address(this).balance;
    }
}

