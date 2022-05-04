pragma solidity ^0.8.0;

contract cashFlow{

    struct condition{
        uint percentage;
        uint unlocktime;
    }

    struct Wallet { 
        uint deposit;
        mapping (address => condition) InEdges;
        mapping (address => uint) OutEdges;
    }

    mapping (address => Wallet) public Wallets;

    function withdraw() public payable returns (bool){

    }

    function deposit() public payable returns (bool){

    }

    function register() public returns(bool){

    }

    function updateEdge() public  returns (bool){

    }

    function inherit() public returns (bool){

    }


}
