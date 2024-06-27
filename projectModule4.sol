// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20,Ownable,ERC20Burnable
{

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender){}

    function mint(address to, uint256 amount)public onlyOwner
    {
        _mint(to, amount);
    }
    struct Entity 
    {
        string name;
        uint256 price;
    }
    

    // Mapping to store available features
    mapping(uint256 => Entity) public features;

    // Mapping to keep track of which features a user has bought
    mapping(address => mapping(uint256 => bool)) public userFeatures;


    // Event to log feature purchases
    event FeaturePurchased(address indexed user, uint256 featureId, string featureName);


    // Add a new feature
    function addFeature(uint256 featureId, string memory name, uint256 price) public onlyOwner 
    {
        features[featureId] = Entity(name, price);
    }

    // Buy a feature
    function buyFeature(uint256 featureId) public
    {
        Entity memory feature = features[featureId];
        require(bytes(feature.name).length != 0, "Feature does not exist");
        require(!userFeatures[msg.sender][featureId], "Feature already purchased");
        require(balanceOf(msg.sender) >= feature.price, "Insufficient balance");

        // Transfer tokens from the user to the contract
        _transfer(msg.sender, address(this), feature.price);

        // Mark the feature as purchased by the user
        userFeatures[msg.sender][featureId] = true;

        // Emit the event
        emit FeaturePurchased(msg.sender, featureId, feature.name);
    }

    // Check if a user has purchased a feature
    function hasPurchasedFeature(address user, uint256 featureId) public view returns (bool) 
    {
        return userFeatures[user][featureId];
    }
    
}
    
