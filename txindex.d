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
import std.format;
import core.stdc.stdint;

import uint256;
import transaction: CTransaction;
import context;



struct TxIndex
{  
	/**
	* **********  TxIndex  **********
	* It contains the Transaction hash.*
	* Total money received.*
	* Total money spend.*
	* Owner public key.*
	*/

	char[64] nTxHash;
	uint64_t nTotalReceived;
	uint64_t nTotalSpend;
	char[130] nOwner;


	this(CTransaction tx)
	{
		/**
		* Add tx to TxIndex
		* Params:
        *     tx = CTransaction object.
		*/

		nTxHash = tx.GetHash().ToString();
		nTotalReceived = tx.nValue;
		nTotalSpend = 0;
		nOwner = tx.nReciptien;
	}


	this(TxIndex* tx)
	{
		/**
		* Add TxIndex* to TxIndex
		* Params:
        *     tx = TxIndex object.
		*/
		nTxHash = tx.nTxHash;
		nTotalReceived = tx.nTotalReceived;
		nTotalSpend= tx.nTotalSpend;
		nOwner = tx.nOwner;
	}


	this(Uint256 hash)
	{
		/**
		* Add txindex that corresponse to hash to TxIndex
		* Params:
        *     hash = uint256 object.
		*/

		foreach (mHash, mIndex; mapTxIndex)
        {
            if (mHash == hash)
                this = mIndex;
        }
	}


	@property bool IsMine()
	{
		/**
		* Returns true if we are owners of the TxIndex otherwise false.*
		*/
		//return key.IsMineKey(cast(string)nOwner);
		return true;
	}


	@property uint64_t getBalance()
	{
		/**
		* Returns the balance of the given TxIndex.*
		*/
		uint64_t fBalance = nTotalReceived - nTotalSpend;
		return fBalance;
	}


	@property uint64_t getTotalSpend()
	{
		/**
		* Returns the total money spend of the given TxIndex.*
		*/
		return nTotalSpend;
	}


	@property string ToString() const
	{
		return format("TxIndex(Hash=%s, nTotalReceived=%d.%08d, nTotalSpend=%d.%08d, nReciptien=%s)", 
			nTxHash, nTotalReceived / COIN, nTotalReceived % COIN, nTotalSpend / COIN, nTotalSpend % COIN, nOwner);
	}


	@property void print()
	{
		writeln(ToString());
	}
}