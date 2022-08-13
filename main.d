// Copyright (c) 2022 Papa Crouz
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


import std.stdio;

import transaction: CTransaction;
import uint256;
import txindex;
import context;
import utils;



CTransaction buildTx()
{
	CTransaction tx = new CTransaction();
	tx.hashPrevTx = 0;
	tx.nMemo = GenerateNewMemo();
	tx.nValue = 50 * COIN;
	tx.nReciptien = "04678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5f";
	return tx;
}



void main()
{
	// build a tx 
	CTransaction tx = buildTx();
	
	// build a TxIndex of given tx
	TxIndex index = tx;
    // get the tx hash 
	auto hash = tx.GetHash();
    // map the transaction on memory 
    mapTxIndex[hash] = index;

    // check if tx hash exists on memory 
    assert(mapTxIndexCanFind(hash));

    // read txindex from memory 
    TxIndex ptr = mapTxIndex[hash];
    
    // check balance 
    assert(ptr.getBalance() == 50 * COIN);
    // check total money spends 
    assert(ptr.getTotalSpend() == 0 * COIN);

    // debit some money
    ptr.nTotalSpend = 25 * COIN;
    assert(ptr.getBalance() == 25 * COIN);
    assert(ptr.getTotalSpend() == 25 * COIN);
    
}