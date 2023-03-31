// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BitDadyDefi is ERC20 {
    uint256 public constant TOTAL_SUPPLY = 21000000;
    uint256 public constant MINING_REWARD = 7000000;
    uint256 public constant STAKING_REWARD = 3000000;
    uint256 public constant DISTRIBUTION = 11000000;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _miners;
    mapping(address => bool) private _stakers;

    address private _owner;
    uint256 private _totalStaked;
    uint256 private _stakingStartTime;

    constructor() ERC20("BitDady", "BTD") {
        _owner = msg.sender;
        _mint(_owner, TOTAL_SUPPLY * (10 ** uint256(decimals())));
        _stakingStartTime = block.timestamp;
    }

    function mine() external {
        require(_miners[msg.sender], "BitDadyDefi: only miners can mine");
        require(block.timestamp >= _stakingStartTime, "BitDadyDefi: staking period has not started yet");

        uint256 reward = MINING_REWARD * (10 ** uint256(decimals()));
        _mint(msg.sender, reward);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "BitDadyDefi: cannot stake 0 tokens");
        require(balanceOf(msg.sender) >= amount, "BitDadyDefi: not enough balance to stake");
        require(!_stakers[msg.sender], "BitDadyDefi: already staking");

        _transfer(msg.sender, address(this), amount);

        _stakers[msg.sender] = true;
        _totalStaked += amount;
    }

    function unstake() external {
        require(_stakers[msg.sender], "BitDadyDefi: not staking");

        uint256 amount = _balances[address(this)] * balanceOf(msg.sender) / _totalStaked;

        _stakers[msg.sender] = false;
        _totalStaked -= balanceOf(msg.sender);

        _transfer(address(this), msg.sender, amount);
    }

    function addMiner(address miner) external {
        require(msg.sender == _owner, "BitDadyDefi: only owner can add miner");
        require(!_miners[miner], "BitDadyDefi: miner already exists");

        _miners[miner] = true;
    }

    function removeMiner(address miner) external {
        require(msg.sender == _owner, "BitDadyDefi: only owner can remove miner");
        require(_miners[miner], "BitDadyDefi: miner does not exist");

        _miners[miner] = false;
    }

    function isMiner(address miner) public view returns (bool) {
        return _miners[miner];
    }

    function isStaking(address staker) public view returns (bool) {
        return _stakers[staker];
    }

    function totalStaked() public view returns (uint256) {
        return _totalStaked;
    }

    function stakingStartTime() public view returns (uint256) {
        return _stakingStartTime;
    }
}


// 0x8638Fc9d507E2a1fA1091FC3AE6ba9DEd0508a75

// 0xEc187AcB56F510deFCD0DE7ef07bA97aa4d23F0b poly
