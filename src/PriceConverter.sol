// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * 1e10);
    }

    function getHistoricalPrice(AggregatorV3Interface priceFeed, uint80 roundId)
        internal
        view
        returns (uint256)
    {
        (, int256 answer, , , ) = priceFeed.getRoundData(roundId);
        return uint256(answer * 1e10);
    }

    function getDecimals(AggregatorV3Interface priceFeed) internal view returns (uint8) {
        return priceFeed.decimals();
    }

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed)
        internal
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice(priceFeed);
        return (ethPrice * ethAmount) / 1e18;
    }

    function convertUsdToEth(uint256 usdAmount, AggregatorV3Interface priceFeed)
        internal
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice(priceFeed);
        return (usdAmount * 1e18) / ethPrice;
    }

    function getLatestTimestamp(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (, , , uint256 updatedAt, ) = priceFeed.latestRoundData();
        return updatedAt;
    }

    function isPriceStale(AggregatorV3Interface priceFeed, uint256 threshold)
        internal
        view
        returns (bool)
    {
        uint256 updatedAt = getLatestTimestamp(priceFeed);
        return block.timestamp - updatedAt > threshold;
    }
}
