// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    enum State { Created, InTransit, Delivered }

    struct Item {
        uint id;
        string name;
        uint quantity;
        uint price;
        address supplier;
        address buyer;
        State state;
    }

    mapping(uint => Item) public items;
    uint public itemCount;

    event ItemCreated(uint indexed id, string name, uint quantity, uint price, address supplier);
    event ItemInTransit(uint indexed id, address buyer);
    event ItemDelivered(uint indexed id, address buyer);

    function createItem(string memory _name, uint _quantity, uint _price) public {
        itemCount++;
        items[itemCount] = Item(itemCount, _name, _quantity, _price, msg.sender, address(0), State.Created);
        emit ItemCreated(itemCount, _name, _quantity, _price, msg.sender);
    }

    function startShipping(uint _id, address _buyer) public {
        Item storage item = items[_id];
        require(item.buyer == address(0), "Item already sold");
        require(item.supplier == msg.sender, "Only supplier can start shipping");
        item.buyer = _buyer;
        item.state = State.InTransit;
        emit ItemInTransit(_id, _buyer);
    }

    function confirmDelivery(uint _id) public {
        Item storage item = items[_id];
        require(item.buyer == msg.sender, "Only buyer can confirm delivery");
        require(item.state == State.InTransit, "Item is not in transit");
        item.state = State.Delivered;
        emit ItemDelivered(_id, msg.sender);
    }
}