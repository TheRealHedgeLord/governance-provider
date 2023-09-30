// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract GovernanceProvider {

    address private owner;

    mapping(address => bool) private activeContracts;
    mapping(address => uint256) private defaultFees;
    mapping(address => mapping(address => uint256)) private specialFees;
    mapping(address => mapping(address => bool)) private freeUserList;
    mapping(address => mapping(address => bool)) private whitelist;
    mapping(address => mapping(address => bool)) private blacklist;

    modifier ownerOnly {
        require(msg.sender == owner, "Governance: Access denied");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function getOwner() public view returns(address) {
        return owner;
    }

    function isActive(
        address contractAddress
    ) public view returns(bool) {
        return activeContracts[contractAddress];
    }

    function isWhitelisted(
        address contractAddress,
        address userAddress
    ) public view returns(bool) {
        return whitelist[contractAddress][userAddress];
    }

    function isBlacklisted(
        address contractAddress,
        address userAddress
    ) public view returns(bool) {
        return blacklist[contractAddress][userAddress];
    }

    function getFee(
        address contractAddress,
        address userAddress
    ) public view returns(uint256) {
        if (freeUserList[contractAddress][userAddress]) {
            return 0;
        } else if (specialFees[contractAddress][userAddress] == 0) {
            return defaultFees[contractAddress];
        } else {
            return specialFees[contractAddress][userAddress];
        }
    }

    function transferOwnership(
        address newOwner
    ) public ownerOnly {
        owner = newOwner;
    }

    function updateActiveContracts(
        address contractAddress,
        bool value
    ) public ownerOnly {
        activeContracts[contractAddress] = value;
    }

    function updateDefaultFees(
        address contractAddress,
        uint256 value
    ) public ownerOnly {
        defaultFees[contractAddress] = value;
    }

    function updateSpecialFees(
        address contractAddress,
        address userAddress,
        uint256 value
    ) public ownerOnly {
        specialFees[contractAddress][userAddress] = value;
    }

    function updateFreeUserList(
        address contractAddress,
        address userAddress,
        bool value
    ) public ownerOnly {
        freeUserList[contractAddress][userAddress] = value;
    }

    function updateWhitelist(
        address contractAddress,
        address userAddress,
        bool value
    ) public ownerOnly {
        whitelist[contractAddress][userAddress] = value;
    }

    function updateBlacklist(
        address contractAddress,
        address userAddress,
        bool value
    ) public ownerOnly {
        blacklist[contractAddress][userAddress] = value;
    }

}