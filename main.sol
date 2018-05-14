pragma solidity ^0.4.21;

contract ReserveVS {

    //<contract_variables>
    uint256 price;
    address public owner;

    mapping (uint => address) private reservation;
    uint private balanceToBeWithDrawn = 0;
    uint public VSCreationDate;
    //</contract_variables>

    function ReserveVS(uint256 pricePerSlot) public {
        price = pricePerSlot;
        owner = msg.sender;
        VSCreationDate = block.timestamp;
    }

    function reserve(uint24 slotId) public payable {
        require(slotId > 0);
	    require(reservation[slotId] == 0);
        require(msg.value >= price);

        balanceToBeWithDrawn += msg.value;
        reservation[slotId] = msg.sender;
    }

    function transfer(uint24 slotId, address to) public {
        require(reservation[slotId] == msg.sender);

        reservation[slotId] = to;
    }

    function validate(address client) public view returns (bool) {
        uint diff = 1 + (block.timestamp - VSCreationDate) / 60 / 30;
        return reservation[diff] == client;
    }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(balanceToBeWithDrawn);
        balanceToBeWithDrawn = 0;
    }

}