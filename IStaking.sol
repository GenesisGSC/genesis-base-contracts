// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

    struct NodeInfo{
        //node address
        address node;
        //Staking total amount
        uint128 total;
    }
//address 0x25201e6ba6E025eF496eDFD9A5AFe501CDc308e3
interface IStaking{
    /* @dev apple to be a candidate
     '_contract'： node 's contract
     'amount'：Staking `amount` of GPs to the node
     'authorId': the result of run "author_rotateKeys" from node 128 bytes
     */
    function join(address _contract,uint256 amount,bytes calldata authorId)  external returns (bool);

    /* @dev out of candidates by node ownner,
    to get the remain GPs, Call `unbond`, then call `withdrawTo` on next Era
    */
    function leave()  external returns (bool);

    /**
     * @dev Get the current operating status of the chain .
     *
     * Returns a boolean value indicating whether it can be operated.
     *
     * Note: If it is in the last 20 blocks of the campaign, it will be inoperable .
     * If the chain is inoperable, means can't deposit and withdraw GP, but still
     * can withdraw the block reward GS.
     */
    function chainOperateStatus() external view returns (bool);

    /*
    @dev node infomation
    Returns 'node' true: candidates or electeds
    'total':   Staking total amount
    'elected':  true: be elected
    */
    function getNodeInfo(address who)  external view returns(bool node, uint256 total, bool elected);

    /* @dev  Returns electeds
    'node' node address
    'total' Staking total amount
    */
    function electeds() external view returns (NodeInfo[] memory nodes);

    /* @dev Returns candidates
    'node' node address
    'total' Staking total amount
    */
    function candidates() external view returns (NodeInfo[] memory nodes);

    /**
      * @dev Get the node contract address
     *
     */
    function getNodeContract(address nodeAccount) external view returns (address);
    /**
     * @dev Get the current status of the node .
     *
     * Returns :
     *     0- not a node
     *     1- Candidate status
     *     2- Elected status
     *     3- Elected status and selected as the current verification nodes
     *
     */
    function nodeStatus(address) external view returns (uint256);

    /**
      when the nodeStatus = 2, but not 3, can call to be 3
    */
    function beValidater() external returns (bool);

    /**
     * @dev Get the minimum pledge amount of GP for node .
     *
     */
    function getMinStakeAmount() external view returns (uint256);

    /**
     * @dev Get the node account bound to the current contract .
     *
     */
    function getNodeAccount(address contractAddress) external view returns (address);

    /**
     * @dev Returns the GP amount of tokens owned by `account` of node.
     */
    function GPBalanceOf(address nodeAccount) external view returns (uint256);


    /**
    * @dev Staking `amount` of GPs to the node using the allowance mechanism.
     * `amount` is then deducted from the `account`'s GP Token allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Note: If the chainOperateStatus=false or the nodeStatus=0 , returns false;
     * otherwise returns true.
     *
     */
    function depositFrom(address account,uint256 amount) external returns (bool);

    /**
    get the withdrawable and locked amount by a node account
    */
    function getLocked(address nodeAccount) external view returns (uint256 withdrawable,uint256 locked);

    /**
    withdraw `amount` of GPs , it will be withdrawable on next Era
    */
    function unbond(uint256 amount) external returns (bool);

    /**
    withdraw all withdrawable of GPs to `recipient`
    */
    function withdrawTo(address recipient) external returns (uint256);

    /* @dev update contract by node ownner
    '_contract':new contract address
     */
    function updateContract(address _contract)  external returns (bool);

    /* @dev update AuthorId by node ownner
     'author_id':the key of running node
     */
    function updateAuthorId(bytes calldata author_id)  external returns (bool);


    /*  @dev get the author_id status, false:not used, true: used
    */
    function isUsedAuthorId(bytes calldata author_id) external view returns (bool);

    /*  @dev get the author_id of node
    */
    function authorIdOf(address node) external view returns (bytes memory);


    event Join(address indexed who,address indexed contract_address, uint256 amount);
    event Leave();
    event Deposit(address indexed node,address indexed who,uint256 amount);
    event Unbond(address indexed node,uint256 amount);
    event Withdraw(address indexed node,address indexed who,uint256 amount);
    event UpdateContract(address);

}

