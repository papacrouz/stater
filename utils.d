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
import core.stdc.time;
import std.algorithm;
import std.conv: to;
import std.digest.sha: toHexString;
import std.range; 
import std.stdio;
import uint256;
import std.bigint;
import core.stdc.time;
import std.datetime;
import std.uuid;

static int64_t nTimeOffset = 0;



// encode hex 
string encodeHex(string i){return (cast(ubyte[]) i).toHexString;}
// decode hex 
string decodeHex(string i){return to!string(i.chunks(2).map!(digits => cast(char) digits.to!ubyte(16)).array);}
// unixtimestamp
int64_t GetTime(){return core.stdc.time.time(null);}
// adjusted time
int64_t GetAdjustedTime(){return GetTime() + nTimeOffset;}


string GenerateNewMemo()
{
    // todo.
    return randomUUID().toString[0..10];
}