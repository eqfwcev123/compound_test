pragma solidity ^0.8.15;

interface CTokenInterface {
	function mint(uint256 mintAmount) external returns (uint256);
	function redeem(uint256 redeemTokens) external returns (uint256); 
	function redeemUnderlying(uin256 redeemAmount) external returns (uint256);
	function borrow(uint256 borrowAmount) external returns (uint256);
	function repayBorrow(uint256 repayAmount) external returns (uint256);
	function underlying() external view returns (address)
}
