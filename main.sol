pragma solidity ^0.4.21;

contract ReserveVS {

    //<contract_variables>
    uint256 price;
    address public owner;
    bool isCreated = false;

    mapping (address => uint) private balanceOf;
    mapping (uint => address) private reservation;
    uint private balanceToBeWithDrawn = 0;
    uint public VSCreationDate;
    //</contract_variables>

    function ReserveVS(uint256 pricePerSlot) public {
        if(!isCreated) {
            price = pricePerSlot;
            owner = msg.sender;
            VSCreationDate = block.timestamp;
            isCreated = true;
        }
    }

    function reserve(uint24 slotId) public payable {
	require(reservation[slotId] == 0);
        require(msg.value >= price);

        balanceOf[msg.sender] -= price;
        balanceToBeWithDrawn += price;
        reservation[slotId] = msg.sender;
    }

    function transfer(uint24 slotId, address to) public {
        require(reservation[slotId] == msg.sender);

        reservation[slotId] = to;
    }

    function validate(address client) public view returns (bool) {
        uint diff = (block.timestamp - VSCreationDate) / 60 / 30;
        return reservation[diff] == client;
    }

    function withdraw() public {
        require(msg.sender == owner);
        balanceOf[owner] += balanceToBeWithDrawn;
        balanceToBeWithDrawn = 0;
    }

}