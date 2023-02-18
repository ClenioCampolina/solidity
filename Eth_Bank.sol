// SPDX-License-Identifier: MIT

pragma solidity >0.8.0;

contract ETHBank {

    address public owner;
    mapping(address=>uint) AccountsBalance;

    struct Guardian{
        address GuardianAddress;
        address SuggestedNewOwner;
    }

    mapping(uint=>Guardian) GuardiansList;
    
    mapping(address=>address) AllowedSpender;




    constructor(){
        owner = msg.sender;
    }

    modifier OnlyOwner {
        require(owner == msg.sender);
        _;
    }

    modifier OnlyGuardian(uint _id) {
        require(GuardiansList[_id].GuardianAddress == msg.sender);
        _;
    }







    function SetGuardian(uint _index, address _GuardianAddress) public OnlyOwner{
        require(_index <= 5,"Invalid index value");
        require(_index > 0,"Invalid index value");

        if(GuardiansList[1].GuardianAddress != _GuardianAddress){
            if(GuardiansList[2].GuardianAddress != _GuardianAddress){
                if(GuardiansList[3].GuardianAddress != _GuardianAddress){
                    if(GuardiansList[4].GuardianAddress != _GuardianAddress){
                        if(GuardiansList[5].GuardianAddress != _GuardianAddress){
                            Guardian memory GS;
                            GS.GuardianAddress = _GuardianAddress;
                            GuardiansList[_index] = GS;
                        }else require(false);
                    }else require(false);
                }else require(false);
            }else require(false);
        }else require(false);

    }

    function SetSuggestedNewOwner(uint _OwnIndex, address _SuggestedNewOwner) public OnlyGuardian(_OwnIndex){
        GuardiansList[_OwnIndex].SuggestedNewOwner = _SuggestedNewOwner;
    }

    function ChangeOwner(uint _OwnIndex, address _SuggestedNewOwner, uint _index1, uint _index2, uint _index3 ) public OnlyGuardian(_OwnIndex){
        // the checks below were removed because they aren't enough. All 5 guardians MUST BE DIFFERENT ADDRESSES!
        // require(GuardiansList[_index1].GuardianAddress != GuardiansList[_index2].GuardianAddress);
        // require(GuardiansList[_index1].GuardianAddress != GuardiansList[_index3].GuardianAddress);
        // require(GuardiansList[_index2].GuardianAddress != GuardiansList[_index3].GuardianAddress);

        if(GuardiansList[_index1].SuggestedNewOwner == _SuggestedNewOwner) {
            if(GuardiansList[_index2].SuggestedNewOwner == _SuggestedNewOwner){
                if (GuardiansList[_index3].SuggestedNewOwner == _SuggestedNewOwner){
                    owner = _SuggestedNewOwner;
                } else require(false);
            } else require(false);
        } else require(false);
    }



    
    fallback() external payable {
        AccountsBalance[msg.sender] += msg.value;
    }

    receive() external payable {
        AccountsBalance[msg.sender] += msg.value;
    }



    function AddSpender(address _Spender) public {
        AllowedSpender[msg.sender] = _Spender;
    }

    function RemoveSpender() public {
        AllowedSpender[msg.sender] = address(0);
    }

    function CheckSpender() public view returns(address) {
        return AllowedSpender[msg.sender];
    }




    function Withdraw(uint _Amount, address _Account , address payable _WithdrawTo, bytes memory _Payload) public returns(bytes memory) {
        
        if(msg.sender != _Account){
            require(AllowedSpender[_Account] == msg.sender,"You are not allowed to spend");
            require(AccountsBalance[_Account] >= _Amount,"The account doesn't have enough funds");
            AccountsBalance[_Account] -= _Amount;
            (bool CallChecker, bytes memory returnData) = _WithdrawTo.call{value:_Amount}(_Payload);
            require (CallChecker);
            return returnData;

        } else {
            require(AccountsBalance[_Account] >= _Amount,"The account doesn't have enough funds");
            AccountsBalance[_Account] -= _Amount;
            (bool CallChecker, bytes memory returnData) = _WithdrawTo.call{value:_Amount}(_Payload);
            require(CallChecker);
            return returnData;
        }
    }
}
