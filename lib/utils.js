const rl = require("readline");
const { BigNumber } = require("@ethersproject/bignumber");
const BN = n => BigNumber.from(n.toString());

const prompt = async (question) => {
  if (hre.network.name === "hardhat") {
    return;
  }

  const r = rl.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
  });

  const answer = await new Promise((resolve, error) => {
    r.question(`${question} [y/n]: `, answer => {
      r.close();
      resolve(answer);
    });
  });

  if (answer !== "y" && answer !== "yes") {
    console.log("exiting...");
    process.exit(1);
  }

  console.log();
};

const prettyNum = (_n) => {
  const n = _n.toString();
  let s = "";
  for (let i = 0; i < n.length; i++) {
    if (i != 0 && i % 3 == 0) {
      s = "_" + s;
    }

    s = n[n.length - 1 - i] + s;
  };

  return s;
}

module.exports = {
  BN,
  prompt,
  prettyNum,
  addr0: "0x0000000000000000000000000000000000000000",
};
