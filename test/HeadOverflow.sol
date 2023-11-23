// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;

import "forge-std/Test.sol";

/// In depth bug Documentation:
/// https://soliditylang.org/blog/2022/08/08/calldata-tuple-reencoding-head-overflow-bug/

contract HeadOverflow is Test {

  struct SendInput {
    /// @dev Chain id of the destination chain. More about chain ids https://docs.zetachain.com/learn/glossary#chain-id
    uint256 destinationChainId;
    /// @dev Address receiving the message on the destination chain (expressed in bytes since it can be non-EVM)
    bytes destinationAddress;
    /// @dev Gas limit for the destination chain's transaction
    uint256 destinationGasLimit;
    /// @dev An encoded, arbitrary message to be parsed by the destination contract
    bytes message;
    /// @dev ZETA to be sent cross-chain + ZetaChain gas fees + destination chain gas fees (expressed in ZETA)
    uint256 zetaValueAndGas;
    /// @dev Optional parameters for the ZetaChain protocol
    bytes zetaParams;
  }

  struct S {
    address x;
    uint[3] y;
  }

  struct T {
    bytes x;
    bytes32[1] y;
  }

  event log(bytes);
  event log2(T);

  function testStaticEncoding(S calldata b, bytes32[2] calldata c) public {
    (bool a, S calldata b1, bytes32[2] calldata c1) = fs(true, b, c);
    assertEq(a, true);
    assertEq(b.x, b1.x);
    for(uint i = 0; i < 3; i++) {
      assertEq(b.y[i], b1.y[i]);
    }
    assertEq(c[0], c1[0]);
    assertEq(c[1], c1[1]);
  }

  function testDynamicEncoding(T calldata b) public {
    emit log(b.x);
    emit log2(b);
  }

  function fs(bool a, S calldata b, bytes32[2] calldata c) public pure 
    returns(bool, S calldata, bytes32[2] calldata) {
    return (a, b, c);  
  }

  function fd(T calldata b) public  {
    emit log(b.x);
  }


}
