// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Marketplace {

    struct Item {
        address seller;
        string name;
        uint256 price;
        bool isSold;
    }

    mapping(uint256 => Item) public items;
    uint256 public itemCount;

    event ItemListed(uint256 itemId, string name, uint256 price, address seller);
    event ItemSold(uint256 itemId, address buyer);

    function listItem(string memory _name, uint256 _price) external {
        require(_price > 0, "Price should be greater than zero");

        itemCount++;
        items[itemCount] = Item({
            seller: msg.sender,
            name: _name,
            price: _price,
            isSold: false
        });

        emit ItemListed(itemCount, _name, _price, msg.sender);
    }

    function buyItem(uint256 _itemId) external payable {
        require(_itemId > 0 && _itemId <= itemCount, "Invalid item ID");
        Item storage item = items[_itemId];
        
        require(!item.isSold, "Item is already sold");
        require(msg.value >= item.price, "Insufficient funds");

        item.isSold = true;
        payable(item.seller).transfer(msg.value);
        emit ItemSold(_itemId, msg.sender);
    }
}
