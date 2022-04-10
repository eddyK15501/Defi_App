const DaiToken = artifacts.require("DaiToken");
const DappToken = artifacts.require("DappToken");
const TokenFarm = artifacts.require("TokenFarm");

module.exports = async function(deployer, network, accounts) {
    //Deploy Mock Dai Token
    await deployer.deploy(DaiToken)
    const daiToken = await DaiToken.deployed()

    //Deploy Dapp Token
    await deployer.deploy(DappToken)
    const dappToken = await DappToken.deployed()

    //Deploy Token Farm
    await deployer.deploy(TokenFarm, daiToken.address, dappToken.address)
    const tokenFarm = await TokenFarm.deployed()

    //Transfer all tokens to the Token Farm (1 million)
    await dappToken.transfer(tokenFarm.address, '1000000000000000000000000')

    //Transfer 100 Mock Dai tokens to investor
    await daiToken.transfer(accounts[1], '100000000000000000000')
};
