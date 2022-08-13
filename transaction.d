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
import std.conv : to;
import std.digest.sha;
import std.algorithm;
import std.range;
import std.bigint;
import std.bitmanip;
import core.stdc.stdint;

import std.uni;


// local
import txindex;
import uint256;
import utils;
import context;




class CTransaction
{
	Uint256 hashPrevTx;
	uint64_t nValue;
	string nMemo;
	string nReciptien;
	string nSignature;

	this()
	{
		SetNull();
	}


	void SetNull()
	{
		hashPrevTx = new Uint256();
	    nValue = 0;
	}




	string serialize(bool hex = true) const
	{
		byte[] header;
		header ~= to!string(hashPrevTx.ToString()).decodeHex;
		header ~= nativeToLittleEndian!ulong(nValue);
		header ~= to!string(nMemo);
		header ~= to!string(nReciptien.decodeHex);
		
		// seialized transaction hex 
		string serialized = toLower((cast(ubyte[]) header).toHexString);
		if (hex)
			return serialized;
		return serialized.decodeHex;
	}


	Uint256 GetHash() const
	{
		auto sha256 = new SHA256Digest();
		return new Uint256(toLower(to!string(toHexString(sha256.digest(sha256.digest(serialize(false)))).chunks(2).array.retro.joiner)));
	}


	string ToString() const
	{
		return format("CTransaction(Hash=%s, hashPrevTx=%s, nValue=%d.%08d, nReciptien=%s)", GetHash().ToString(), hashPrevTx.ToString(), nValue / COIN, nValue % COIN, nReciptien);
	}


	void print()
	{
		writeln(ToString());
	}
}