// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "./VerifySignature.sol";

contract SyneidoLab is ERC1155, Ownable, ERC1155Supply, VerifySignature {
    constructor() ERC1155("") {}

    mapping(address => uint) public numberSftsPerUser;

    uint private constant idToken = 1;

    uint public constant MAX_SUPPLY = 400;

    uint public supply = 0;

    uint private constant PRICE_PUBLIC = 0.02 ether;

    function mintOwner(uint256 amount) external onlyOwner {
        numberSftsPerUser[msg.sender] = amount;
        supply += amount;
        _mint(msg.sender, idToken, amount, " ");
    }

    function freeMint(address _account) external {
        require(numberSftsPerUser[_account] == 0, "Pass Syneido Lab already bought");
        require(supply + 1 <= MAX_SUPPLY, "Max supply exceeded");
        supply += 1;
        numberSftsPerUser[_account] = 1;
        _mint(_account, idToken, 1, " ");
    }

    function gift(address _account) external onlyOwner {
        require(numberSftsPerUser[_account] == 0, "Pass Syneido Lab already bought");
        require(supply + 1 <= MAX_SUPPLY, "Max supply exceeded");
        supply += 1;
        numberSftsPerUser[_account] = 1;
        _mint(_account, idToken, 1, " ");
    }

    function publicMint(address _account) external payable {
        require(numberSftsPerUser[_account] == 0, "Pass Syneido Lab already bought");
        require(msg.value >= PRICE_PUBLIC, "Not enought funds");
        require(supply + 1 <= MAX_SUPPLY, "Max supply exceeded");
        supply += 1;
        numberSftsPerUser[_account] = 1;
        _mint(_account, idToken, 1, " ");
    }

    function uri(uint _tokenId) override public pure returns(string memory) {
        return string(abi.encodePacked("ipfs://bafybeici3gq75q3ngf6y4gthrsblviztxwendgw3klrfyp3h3v7ik7ys7m/",
        Strings.toString(_tokenId), ".json"));
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
