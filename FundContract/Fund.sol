// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;

// get price feed with Chainlink; for getting real world market price data
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//this contract accepts some sort of payment
contract Fund {
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    //will be immediately executed when we deploy this contract
    constructor() public {
        owner = msg.sender;
    }

    //payable key word indicates that the function is used to pay for things
    //when you make a transaction, you can append a eth value to the function call
    function fund() public payable {
        uint256 minimumUSD = 50 * 10**18;

        //if the conversation rate of msg.value is less than minimumUSD, then revert the transaction (user gets their money back
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "You need to spend more ETH!"
        );

        //msg.sender is the sender of the function call
        //msg.value is how much they sent
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    //making a contract call to another contract from OUR contract using an interface
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        ); //this address is located on a testnet, not a simulated chainlink
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        //since we're using an interface from chainlink, we can't
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 10000000000);
    }

    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1000000000000000000;
        return ethAmountInUsd;
    }

    //checks msg.sender has to be the owner
    //if it is, run the rest of the code "_;"
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    //withdraw funding from the contract
    function withdraw() public payable onlyOwner {
        //transfer() is a function we can call on any address to send eth to another address
        //"this" refers to the contract you're in
        //.balance gets the balance of the contract address
        payable(msg.sender).transfer(address(this).balance);

        //reset all the funders that used the contract
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }

        //set funders to a new array of size 0
        funders = new address[](0);
    }
}
