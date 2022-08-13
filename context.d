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


import core.stdc.stdint;


import txindex: TxIndex;
import uint256;

static const uint64_t COIN = 100000000;

__gshared TxIndex[Uint256] mapTxIndex;





////////////// MapTxIndex

bool mapTxIndexCanFind(Uint256 hash)
{
	/**
	* Dertemine whenever a transaction is on mapTxIndex
	* Params:
    *     hash = uint256 object.
    * Returns: true if the hash exists otherwise false.
	*/

	TxIndex* ptr;

	ptr = (hash in mapTxIndex);
	
	if (ptr !is null)
		return true;
	return false;
}