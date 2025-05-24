// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CharityDonationTracker is Ownable {
    struct Charity {
        string name;
        uint256 totalReceived;
        bool exists;
    }

    mapping(address => Charity) public charities;
    address[] public charityList;

    event DonationReceived(address indexed donor, address indexed charity, uint256 amount);
    event CharityAdded(address indexed charityAddress, string name);
    event CharityRemoved(address indexed charityAddress);

    constructor() Ownable(msg.sender) {}

    function addCharity(address charityAddress, string calldata name) external onlyOwner {
        require(!charities[charityAddress].exists, "Charity already exists");
        charities[charityAddress] = Charity(name, 0, true);
        charityList.push(charityAddress);
        emit CharityAdded(charityAddress, name);
    }

    function removeCharity(address charityAddress) external onlyOwner {
        require(charities[charityAddress].exists, "Charity does not exist");
        charities[charityAddress].exists = false;

        for (uint i = 0; i < charityList.length; i++) {
            if (charityList[i] == charityAddress) {
                charityList[i] = charityList[charityList.length - 1];
                charityList.pop();
                break;
            }
        }
        emit CharityRemoved(charityAddress);
    }

    function donate(address charityAddress) external payable {
        require(charities[charityAddress].exists, "Charity not registered");
        require(msg.value > 0, "Donation must be greater than 0");

        charities[charityAddress].totalReceived += msg.value;
        payable(charityAddress).transfer(msg.value);

        emit DonationReceived(msg.sender, charityAddress, msg.value);
    }

    function getCharities() external view returns (address[] memory) {
        return charityList;
    }

    function getCharityDetails(address charityAddress) external view returns (string memory name, uint256 totalReceived, bool exists) {
        Charity memory c = charities[charityAddress];
        return (c.name, c.totalReceived, c.exists);
    }
}
