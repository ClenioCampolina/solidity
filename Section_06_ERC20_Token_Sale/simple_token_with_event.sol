//SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0;

contract simpleTokenWithEvent {

    mapping (address => uint) public TokenBalances;

    event TokensWereSent(address _from, address _to, uint _amount);

    constructor() {
        TokenBalances[msg.sender] = 1000;
    }

    function SendTokens (address _to, uint _amount) public returns(bool) {
        require(TokenBalances[msg.sender] >= _amount, "Not enough tokens");
        TokenBalances[msg.sender] -= _amount;
        TokenBalances[_to] += _amount;

        emit TokensWereSent(msg.sender, _to, _amount);
        return true;
    }
}