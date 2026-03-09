const { ethers } = require("hardhat");

async function main() {

    const Oracle = await ethers.getContractFactory("AMLOracle");
    const oracle = await Oracle.deploy();

    await oracle.waitForDeployment();

    console.log("Oracle:", oracle.target);

    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy();

    await token.waitForDeployment();

    console.log("Token:", token.target);

    const Hook = await ethers.getContractFactory("AMLHook");
    const hook = await Hook.deploy();

    await hook.waitForDeployment();

    console.log("Hook:", hook.target);

    const Vault = await ethers.getContractFactory("ProxyVault");
    const vault = await Vault.deploy(
        "USER_ADDRESS",
        oracle.target
    );

    await vault.waitForDeployment();

    console.log("Vault:", vault.target);
}

main();