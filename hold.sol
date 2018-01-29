pragma solidity ^0.4.0;

contract Hold {

    uint withdrawTime = 1517085048;

    struct Holder
    {
        address holder;
        uint amount;
    }

    mapping(address => Holder) holders;

    modifier onlyBefore(uint _time)
    {
        require(now < _time);
        _;

    }

    modifier onlyAfter(uint _time)
    {
        require(now > _time);
        _;

    }

    modifier hasFunds(uint _hasAmount)
    {
        Holder storage sender = holders[msg.sender];
        require(sender.amount >= _hasAmount);
        _;
    }

    function deposit()
        public
        payable
        onlyBefore(withdrawTime)
        returns (bool)
    {
        Holder storage sender = holders[msg.sender];
        sender.amount += msg.value;
        return true;
    }

    function withdraw(uint _amount)
        public
        onlyAfter(withdrawTime)
        hasFunds(_amount)
        returns (bool)
    {
        Holder storage sender = holders[msg.sender];
        sender.amount -= _amount;
        msg.sender.transfer(_amount);
        return true;
    }

}
