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


import std.file;


// local 
import key;
import database;
import transaction: CTransaction;
import uint256;
import txindex;
import context;
import utils;



CTransaction buildTx()
{
	CTransaction tx = new CTransaction();
	tx.hashPrevTx = 0;
	tx.nMemo = "example ptr";
	tx.nValue = 50 * COIN;
	tx.nReciptien = "04678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5f";
	return tx;
}



void test1()
{

	// create an empty datadir
	auto dir = "testdb";
	dir.mkdir;
    // on exit delete the directory 
	scope(exit) rmdirRecurse(dir);

	int r;
    // initialize db
    r = database_init("testdb");

    if(r != 0)
    {
    	writeln("Fail to initialize database");
    }



	// build a tx 
	CTransaction tx = buildTx();
	
	// build a TxIndex of given tx
	TxIndex index = tx;

    // map the transaction on memory 
    mapTxIndex[tx.GetHash()] = index;

    // check if tx hash exists on memory 
    assert(mapTxIndexCanFind(tx.GetHash()));

    // read txindex from memory 
    TxIndex ptr = readTxIndex(tx.GetHash());
    
    // check balance 
    assert(ptr.getBalance() == 50 * COIN);
    // check total money spends 
    assert(ptr.getTotalSpend() == 0 * COIN);
    

    // we have to keep a copy on disk of the txindex 
    // store txindex in to memory.
    bool stored = store_txindex(&index);
    // stored ?
    assert(stored);

    // clear memory mapTxIndex
    mapTxIndex.clear(); 
    

    // as we above clear the maptxindex, this should be false 
    // maptxindex is empty
    assert(mapTxIndexCanFind(tx.GetHash()) == false);

    // load txindexes from db in to memory  
    loadTxIndex();
    
    // due to loadTxIndex this should be not fail
    // because loadTxIndex loads each txindex from db 
    // into maptxindex.
    assert(mapTxIndexCanFind(tx.GetHash()));

    TxIndex iv = readTxIndex(tx.GetHash());


    assert(iv.getBalance() == 50 * COIN);

    // spend some money
    iv.nTotalSpend = 25 * COIN;
    assert(iv.getBalance() == 25 * COIN);

    // update txindex changes on memory, 25 coins have been spend.
    mapTxIndex[tx.GetHash()] = iv;

    // update txindex changes on disk with new spends
    bool updated = store_txindex(&iv);

    assert(updated);

    // clear memory mapTxIndex
    mapTxIndex.clear(); 

    // load txindexes from db in to memory witch previously we clear.
    loadTxIndex();

    assert(mapTxIndexCanFind(tx.GetHash()));

    TxIndex qw = readTxIndex(tx.GetHash());


    assert(qw.getBalance() == 25 * COIN);
}

void test2()
{

    
    CKey key = new CKey();
    key.MakeNewKey();
    assert(key.GetPubKeyHex().length == 130);
    writeln(key.GetPubKeyHex());





}


void main()
{
    test2();
}