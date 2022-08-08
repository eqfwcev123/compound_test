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

	//// @param : cTokenAddress: underlying address of the cToken
	//// @param : Amount of underlying that we want to lend (ex: underlyingAmount of DAI that we want to lend)
	function supply(address cTokenAddress, uint256 underlyingAmount) external {
		CTokenInterface cToken = CTokenInterface(cTokenAddress);
		address underlyingAddress = cToken.underlying();

		// approve underlying token to be spent by compound
		IERC20(underlyingAddress).approve(cTokenAddress, underlyingAmount);

		// Return 0 if success, else fail
		uint256 result = cToken.mint(underlyingAmount);
		require(result == 0, "cToken#mint() failed");
	}

	function redeem(address cTokenAddress, uint256 cTokenAmount) external {
		CTOkenInterface cToken = CTOkenInterface(cTokenAddress);
		uint256 result = cToken.redeem(cTokenAmount);
		require(result == 0, "cToken#redeem() failed");
	}

	function enterMarket(address cTokenAddress) external {
		// array of cToken address that we want to use as collateral
		address[] memory markets = new address[](1);
		markets[0] = cTokenAddress;
		uint256[] memory results = comptroller.enterMarkets(cTokens);
		require(
			results[0] == 0	, "comptroller#enterMarket() failed"
		);
	}

	function borrow(address _cTokenAddress, uint256 borrowAmount) external {
		CTOkenInterface cToken = CTOkenInterface(cTokenAddress);
		address underlyingAddress = cToken.underlying();
		uint256 result = cToken.borrow(borrowAmount);
		require(result == 0, "cToken#borrow() failed");
	}

	function repayBorrow(address cTokenAddress, uint256 underlyingAmount) external {
		CTOkenInterface cToken = CTOkenInterface(cTokenAddress);
		address underlyingAddrss = cToken.underlying();
		IERC20(underlyingAddress).approve(cTokenAddress, underlyingAmount);
		uint256 result = cToken.repayBorrow(underlyingAmount);
		require(result == 0, "cToken#repayBorrow() failed");
	}

	function getMaxBorrow(address cTokenAddress) external {
		(uint256 result, uint256 liquidity, uin256 shortfall) = comptroller.getAccountLiquidity(address(this));
		require(result == 0, "comptroller#getAccountLiquidity() failed");
		require(shortfall == 0, "Account underwater");
		require(liquidity > 0, "Account does not have enough collateral");
		uint256 underlyingPrice = priceOracle.getUnderlyingPrice(cTokenAddress);
		return liquidity / underlyingPrice;
	}
}
