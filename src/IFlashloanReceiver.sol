// Interface of the other contract
interface IFlashloanReceiver {
    function flashloan_receive(uint256 amount, address token) external;
}
