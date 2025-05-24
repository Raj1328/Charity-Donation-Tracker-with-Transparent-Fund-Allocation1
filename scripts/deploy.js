const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying CharityDonationTracker contract with account:", deployer.address);

  const CharityDonationTracker = await hre.ethers.getContractFactory("CharityDonationTracker");
  const charityDonationTracker = await CharityDonationTracker.deploy();

  await charityDonationTracker.deployed();

  console.log("CharityDonationTracker deployed to:", charityDonationTracker.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
