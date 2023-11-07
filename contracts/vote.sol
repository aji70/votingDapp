// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Vote{

     uint256 ClosingTime;
     uint256 candidateRegistrationTimeDeadline;
    
    
    struct Voter{
       uint256 VotingId;
        uint256 personalId;
       }

       struct Candidate{
        string candidateName;
        string candidateParty;
        string aspiringPosition;
       }

     uint uniqueKey = 8;
    uint uniqueKeyM = 10 ** uniqueKey;
    uint256 public  Candidate1;
    uint256 public Candidate2;
    uint256 public Candidate3;
    Voter [] public voters;
    Candidate[] public candidates;

    uint256 public TotalNumberOfRegisteredVoters = voters.length;
    event Registered(address indexed sender, string message,string message1);
    event Registered1(address indexed sender,string message1, uint256 votersIndex);
    event CandidateregistrationEvent(address indexed sender, uint256 CandidateKey, string Congratulations);
    
    constructor() {
        uint256 _ClosingTime = block.timestamp + 7200;
        ClosingTime = _ClosingTime;
        uint _candidateRegistrationTimeDeadline = block.timestamp + 1800;
        candidateRegistrationTimeDeadline = _candidateRegistrationTimeDeadline;
    }
    
    mapping(address => bool) hasVoted;
    mapping(address => uint256) voterToID;
    mapping(address => uint256) userPassword;
    mapping(address => bool) voterRegister;
    mapping(address => bool) candidateRegister;
    mapping(address => bool) viewed;
    mapping(address => uint256) voterIndexed;
    mapping(address => uint256) candidateRegistraionKey;
    mapping(address => uint256) candidateIndexed;
    


    function TimeRemaining() public view returns(uint256){
         uint256 Timeremainin = (ClosingTime - block.timestamp) / 60;
         return  Timeremainin;
    }

    function candidateKeyPurchase(uint256 _createID) public payable{
        // require(msg.value = 0.1 ether, "Not enough funds");
       address owner = msg.sender;
        uint256 randomizingAddr = uint256(keccak256(abi.encodePacked(owner)));
       uint256 randonizingId = uint256(keccak256(abi.encodePacked(_createID)));
       uint256 randomkey = uint256(keccak256(abi.encodePacked(randonizingId + randomizingAddr)));
        uint256 _candidateKey =  randomkey % uniqueKeyM;
        candidateRegistraionKey[owner] = _candidateKey;

        emit CandidateregistrationEvent(owner, _candidateKey, "Candidate Registration Key Purchased successfully");

    }
    function candidateRegistration(uint256 _candidateKey,
                                    string memory _candidateName,
                                    string memory _candidateParty,
                                    string memory _aspiringPosition) 
                                    public{
        require(candidateRegistraionKey[msg.sender] == _candidateKey, "Wrong Candidate Key");
        require(block.timestamp <= candidateRegistrationTimeDeadline, "Candidate Registration is closed");
        require(!candidateRegister[msg.sender], "You have already Registered");
        candidates.push(Candidate(_candidateName, _candidateParty, _aspiringPosition));
        uint256 candidateVotingIndex = candidates.length - 1;
        candidateIndexed[msg.sender] = candidateVotingIndex;
        candidateRegister[msg.sender] = true;



    }


     function votersRegistration(uint256 _createID) public{
       require(block.timestamp <= (ClosingTime - 60), " Voters Registration is closed");
       require(!voterRegister[msg.sender], "You have already Registered");
       address owner = msg.sender;
       uint256 randomizingAddr = uint256(keccak256(abi.encodePacked(owner)));
       uint256 randonizingId = uint256(keccak256(abi.encodePacked(_createID)));
       uint256 randomkey = uint256(keccak256(abi.encodePacked(randonizingId + randomizingAddr)));
        uint256 _VotingId =  randomkey % uniqueKeyM;
        voters.push(Voter(_VotingId, _createID));
        voterToID[msg.sender] = _VotingId;
        userPassword[msg.sender] = _createID;
        voterRegister[msg.sender] = true;
        hasVoted[msg.sender] = false;
       uint256 votersIndex = voters.length - 1;
       voterIndexed[msg.sender] = votersIndex;
        emit Registered1(msg.sender, "Registration successful", votersIndex);

    }

    function viewVoterProfile(uint256 _id, uint256 votersIndex) public returns (Voter memory)  {
        require(userPassword[msg.sender] == _id, "Incorrect Password");
        require(voterIndexed[msg.sender] == votersIndex, "Not your profile");
        require(!viewed[msg.sender], "View profile already");
         viewed[msg.sender] = true;
        return voters[votersIndex];
    }

    function vote(uint256 _VotingId) public {
        require(block.timestamp <= (ClosingTime), " Voting is closed");
        require(voterToID[msg.sender] == _VotingId, "Not your account");
        require(!hasVoted[msg.sender], "You have voted");        
        hasVoted[msg.sender] = true;
        
        emit Registered(msg.sender ,"", "Voted successful");

    }

} 
