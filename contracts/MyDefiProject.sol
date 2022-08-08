pragma solidity ^0.8.15;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './ComptrollerInterface.sol'; 
import './CTokenInterface.sol';
import './PriceOracleInterface.sol';

contract MyDefiProject {
	ComptrollerInterface public comptroller;
	PriceOracleInterface public priceOracle;

	constructor(address _comptroller,address _priceOracle) {
		comptroller = ComptrollerInterface(_comptroller);
		priceOracle = PriceOracleInterface(_priceOracle);
	}

	//// @param : cTokenAddress: Address of the cToken that we want to lend
	//// @param : Amount of underlying that we want to lend (ex: underltingAmount of DAI that we want to lend)
	function supply(address cTokenAddress, uint256 underlyingAmount) external {
		CTokenInterface cToken = CTokenInterface(cTokenAddress);
		address underlyingAddress = cToken.underlying();

		// approve underlying token to be spent by compound
		IERC20(underlyingAddress).approve(cTokenAddress, underlyingAmount);

		// Return 0 if success, else fail
		uint256 result = cToken.mint(underltingAmount);
		require(result == 0, "cToken#mint() failed");
	}

	function redeem(address cTokenAddress, uint256 cTokenAmount) external {
		CTOkenInterface cToken = CTOkenInterface(cTokenAddress);
		uint256 result = cToken.redeem(cTokenAmount);
		require(result == 0, "cToken#mint() failed");
	}
}
