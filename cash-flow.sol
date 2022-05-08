pragma solidity ^0.8.0;

contract cashFlow{


    // condition for release of funds
    struct Edge{
        uint unlocktime;
        uint deposit;
    }


    struct Node { 
        uint vault;
        mapping (address => Edge) OutEdges;
        mapping (address => uint) InEdgeIndex;
        address[] InEdges;
    }

    address payable wallet;
    mapping (address => Node) public Nodes;

    constructor(address payable _wallet){
        wallet = _wallet;
    }
    
    modifier hasBalance(uint value){
        require(Nodes[msg.sender].vault >= value);
        _;
    }

    function withdraw(uint value) public payable hasBalance(value){
        Nodes[msg.sender].vault -= value;
        payable(msg.sender).transfer(value);
    }

    function deposit() public payable{
        wallet.transfer(msg.value);
        Nodes[msg.sender].vault += msg.value;
    }

    // function register() public{
    //     Nodes[msg.sender].vault = 0;
    // }

    function addEdge(address hier, uint value, uint, uint locktime) public hasBalance(value){
        require(Nodes[msg.sender].OutEdges[hier].deposit == 0);
        Nodes[msg.sender].vault -= value;
        Nodes[msg.sender].OutEdges[hier].deposit += value;
        Nodes[msg.sender].OutEdges[hier].unlocktime = locktime;
        Nodes[hier].InEdges.push(msg.sender);
        Nodes[hier].InEdgeIndex[msg.sender] = Nodes[hier].InEdges.length - 1;
    }

    function removeEdge(address hier) public {
        uint temp = Nodes[msg.sender].OutEdges[hier].deposit;
        Nodes[msg.sender].OutEdges[hier].deposit = 0; 
        Nodes[msg.sender].OutEdges[hier].unlocktime = 0; 
        Nodes[msg.sender].vault += temp;
        uint index = Nodes[hier].InEdgeIndex[msg.sender];
        Nodes[hier].InEdges[index] = Nodes[hier].InEdges[Nodes[hier].InEdges.length - 1];
        Nodes[hier].InEdgeIndex[Nodes[hier].InEdges[Nodes[hier].InEdges.length - 1]] = Nodes[hier].InEdgeIndex[Nodes[hier].InEdges[index]];
        Nodes[hier].InEdges.pop();
    }

    function inherit() public{
        for (uint i = 0; i < Nodes[msg.sender].InEdges.length; i++){
            address parent = Nodes[msg.sender].InEdges[i];
            if (Nodes[parent].OutEdges[msg.sender].unlocktime > block.timestamp){
                uint temp = Nodes[parent].OutEdges[msg.sender].deposit;
                Nodes[parent].OutEdges[msg.sender].deposit = 0;
                Nodes[msg.sender].vault+= temp;
                if ( i == 0 ){
                    uint ex = Nodes[parent].vault;
                    Nodes[parent].vault = 0;
                    Nodes[msg.sender].vault+= ex;
                }
            }
        }
    }


}
