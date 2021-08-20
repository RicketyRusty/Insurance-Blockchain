// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0 ;


contract insuranceCL{

    address public policyholder ;
    string infoipfs ;
    uint premium ;
    bool paymentdue ;
    bool claimed ;
    bool init ;

    modifier initOnly(){
        require(!init , "Insurance Already Initialized");
        _;
        init = true ;
    }

    modifier onlyAdmin(){
        require(msg.sender == 0x7e9e9cfd7180054115e3910FdD7f8A5D962de7C8 , "Access Denied : Caller is not Admin");
        _;
    }

    modifier claimedstatus(){
        require(!claimed , "Insurance Already Claimed") ;
        _;
    }

    event Status(
        uint date ,
        address PolicyHolder ,
        address policy ,
        string message 
    ) ;

    event Payment(
        uint date ,
        address PolicyHolder ,
        address policy ,
        string ipfshash
    ) ;
    
    //Initialize function
    function initializeProfile(address _addr , string memory _ipfs) public initOnly{
        policyholder = _addr ;
        infoipfs = _ipfs ;
        emit Status(block.timestamp, policyholder, address(this) , "The Insurance Policy is initialized") ;
    }

    //set basic policy info by manager
    function setInfo(uint _premium, bool _payment) external onlyAdmin claimedstatus{
        premium = _premium ;
        paymentdue = _payment ;
        claimed = false ;
        emit Status(block.timestamp, policyholder, address(this) , "The Insurance Policy is set by the manager") ;
    }

    //Set Bill Payment status
    function setPayment(bool _payment) external {
        require((msg.sender == policyholder || msg.sender == 0x7e9e9cfd7180054115e3910FdD7f8A5D962de7C8) && !claimed, "Unauthorized Call : Access Denied") ;
        paymentdue = _payment   ;
        if(paymentdue == true){
            emit Payment(block.timestamp, policyholder, address(this) , infoipfs) ;
        }  
    }

    //Update Profile in case of error or modification
    function updateProfile(address _addr , string calldata _ipfs) external onlyAdmin claimedstatus{
        init = false ;
        initializeProfile(_addr , _ipfs) ;
        emit Status(block.timestamp, policyholder, address(this) , "The Insurance Policy profile got updated") ;
    }

    
    //Restricted Function
    function setClaim(bool _status) external onlyAdmin{
        claimed = _status ;
        if(claimed == true){
            emit Status(block.timestamp, policyholder, address(this) , "The Insurance Policy is claimed") ;
        }
    } 
}




contract insuranceRB{

    address public policyholder ;
    string infoipfs ;
    uint premium ;
    bool paymentdue ;
    bool claimed ;
    bool init ;

    modifier initOnly(){
        require(!init , "Insurance Already Initialized");
        _;
        init = true ;
    }

    modifier onlyAdmin(){
        require(msg.sender == 0x7e9e9cfd7180054115e3910FdD7f8A5D962de7C8 , "Access Denied : Caller is not Admin");
        _;
    }

    modifier claimedstatus(){
        require(!claimed , "Insurance Already Claimed") ;
        _;
    }

    event Status(
        uint date ,
        address PolicyHolder ,
        address policy ,
        string message 
    ) ;
    
    //Initialize function
    function initializeProfile(address _addr , string memory _ipfs) public initOnly{
        policyholder = _addr ;
        infoipfs = _ipfs ;
        emit Status(block.timestamp, policyholder, address(this) , "The Insurance Policy is initialized") ;
    }

    //set basic policy info by manager
    function setInfo(uint _premium, bool _payment ) external onlyAdmin claimedstatus{
        premium = _premium ;
        paymentdue = _payment ;
        claimed = false ;
        emit Status(block.timestamp, policyholder, address(this) , "The Insurance Policy is set by the manager") ;
    }

    //Set Bill Payment status
    function proceedClaim() external claimedstatus{
        require((msg.sender == policyholder || msg.sender == 0x7e9e9cfd7180054115e3910FdD7f8A5D962de7C8), "Unauthorized Call : Access Denied") ;
        //call payment function , upon success :
        paymentdue = true ;
        claimed = true ;
    }

    //Update Profile in case of error or modification
    function updateProfile(address _addr , string calldata _ipfs) external onlyAdmin claimedstatus{
        init = false ;
        initializeProfile(_addr , _ipfs) ;
        emit Status(block.timestamp, policyholder, address(this) , "The Insurance Policy profile got updated") ;
    }

    
    //Restricted Function
    function setClaim(bool _status) external onlyAdmin{
        claimed = _status ;
        if(claimed == true){
            emit Status(block.timestamp, policyholder, address(this) , "The Insurance Policy is claimed") ;
        }
    } 
}