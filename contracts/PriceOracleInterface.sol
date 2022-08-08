pragma solidity ^0.8.15;

interface PriceOracleInterface {
	function getUnderlyingPrice(address asset) external view returns(uint256);
}

