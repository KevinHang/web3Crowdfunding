// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFund {
    // can think it as an object which contains the types
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image; // image as string because we put image url
        address[] donators;
        uint256[] donations;
    }


    // we do this such that we can access campagings[0]
    mapping(uint256 => Campaign) public campaings;

    uint256 public numberOfCampaigns = 0;

    // if parameter only for this specific functions, then put _ before the parameter
    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        Campaign storage campaign = campaings[numberOfCampaigns];

        // checks if everything is okey
        require(campaign.deadline < block.timestamp, "The deadline should be in the future.");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    function donateToCampagn(uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaings[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (campaings[_id].donators, campaings[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        // we are not actually returning all the existing campaigns
        // rather we create an empty Campaign empty with the same number of elements
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaings[i];

            allCampaigns[i] = item;
        }

        return allCampaigns;
    }


}