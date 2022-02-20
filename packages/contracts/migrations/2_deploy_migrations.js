const Hufficorn = artifacts.require('./Hufficorn.sol')
const HufficornGame = artifacts.require('./HufficornGame.sol')

module.exports = function(deployer) {
  deployer.deploy(Hufficorn, "one144u9e92kyhjwstx6utue0ntq8z5wekgwr2lkxt");
  deployer.deploy(HufficornGame, "0x49d144E8B7115C9802eB8806C86c2753a3c40932");
};
