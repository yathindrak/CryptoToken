pragma solidity ^0.8.0;

import "./IERC20.sol";

contract YathindraCoin is IERC20 {
    // 1 token = 0.0001 ETH <= ICO
    uint256 _totalSupply = 1000000;
    uint256 issuedSupply = 0;
    uint initialTokenValue = 0.0001 ether;
    
    mapping (address => uint256) public balances;
    
    mapping (address => mapping (address => uint256)) public allowances;
    
    constructor () {
        address ownerAddress = address(0x123);
        balances[ownerAddress] = _totalSupply * 30 / 100;
        issuedSupply = _totalSupply * 30 / 100;
    }
    
    function mintToken() external payable {
        require(msg.value >= initialTokenValue);
        uint256 numTokens = msg.value - (msg.value % initialTokenValue);
        require(numTokens <= (_totalSupply - issuedSupply));
        
        balances[msg.sender] = balances[msg.sender] + numTokens;
        issuedSupply = issuedSupply + numTokens;
    }
    
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) external view override returns (uint256) {
        return balances[account];
    }
    
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        require(balances[msg.sender] >= amount);
        
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        
        emit Transfer(msg.sender, recipient, amount);
        
        return true;
    }
    
    function approve(address spender, uint256 amount) external override returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    function allowance(address owner, address spender) external view override returns (uint256) {
        return allowances[owner][spender];
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        require(recipient == msg.sender);
        require(balances[sender] >= amount);
        
        balances[sender] = balances[sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        
        emit Transfer(sender, recipient, amount);
        
        return true;
    }
}