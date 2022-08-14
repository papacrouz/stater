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
import std.conv;
import core.stdc.stdint;
import core.stdc.stdlib;
import std.file;

import lmdb;

// local 
import txindex;
import uint256;
import context;



__gshared static MDB_env *env;
__gshared static MDB_dbi db_txindexes;
__gshared static MDB_dbi db_keys;



static void database_close()
{
    writeln("Closing database");
    mdb_dbi_close(env, db_txindexes);
    mdb_env_close(env);
}


__gshared static int database_init(const char* data_dir)
{
    int rc = 0;
    char *err = null;
    MDB_txn *txn = null;

    rc = mdb_env_create(&env);
    mdb_env_set_maxdbs(env, cast(MDB_dbi)2);

    if ((rc = mdb_env_open(env, data_dir, MDB_NOMETASYNC|MDB_WRITEMAP|MDB_MAPASYNC, std.conv.octal!664)) != 0)
    {
        err = mdb_strerror(rc);
        writeln(format("%s (%s)", err, data_dir));
        exit(rc);
    }

    if ((rc = mdb_env_set_mapsize(env, 1073741824)) != 0) {
		writeln(format("%s (%s)", err, data_dir));
		exit(rc);
	}
    
    if ((rc = mdb_txn_begin(env, null, 0, &txn)) != 0)
    {
        err = mdb_strerror(rc);
        writeln(format("%s (%s)", err, data_dir));
        exit(rc);
    }
    uint32_t flags = MDB_INTEGERKEY | MDB_CREATE | MDB_DUPSORT | MDB_DUPFIXED;

    // transaction indexes 
    if ((rc = mdb_dbi_open(txn, "txindexes", flags, &db_txindexes)) != 0)
    {
        err = mdb_strerror(rc);
        writeln(format("%s (%s)", err, data_dir));
        exit(rc);
    }

    // keys indexes 
    if ((rc = mdb_dbi_open(txn, "keysindexes", flags, &db_keys)) != 0)
    {
        err = mdb_strerror(rc);
        writeln(format("%s (%s)", err, data_dir));
        exit(rc);
    }

    
    rc = mdb_txn_commit(txn);



    return rc;
}



__gshared static bool store_txindex(TxIndex *txindex)
{
    int rc = 0;
    char *err = null;
    MDB_txn *txn = null;
    MDB_cursor *cursor = null;
    if ((rc = mdb_txn_begin(env, null, 0, &txn)) != 0)
    {
        err = mdb_strerror(rc);
        writeln(format("%s (%s)", err, "data_dir"));
        return false;
    }
    if ((rc = mdb_cursor_open(txn, db_txindexes, &cursor)) != 0)
    {
        err = mdb_strerror(rc);
        writeln(format("%s (%s)", err, "data_dir"));
        mdb_txn_abort(txn);
        return false;
    }

    MDB_val key =  MDB_val(cast(void*)&txindex.nTxHash, txindex.nTxHash.sizeof);
    MDB_val val =  MDB_val(cast(void*)txindex, TxIndex.sizeof);
    rc = mdb_cursor_put(cursor, &key, &val, MDB_APPEND);

    if (rc != 0)
    {
      
        // already have txindex, update with new changes.
        rc = mdb_cursor_put(cursor, &key, &val, MDB_CURRENT);
        if (rc != 0)
        {
            err = mdb_strerror(rc);
            writeln(format("%s (%s)", err, "data_dir"));
            mdb_txn_abort(txn);
            return false;
        }
    }


    rc = mdb_txn_commit(txn);

    // clear 

    if(rc != 0)
    	return false;
    return true;
}




bool loadTxIndex()
{

	/**
	* Load all txindex's from database in to memory. 
	*/


	int rc = 0;
    char *err = null;
    MDB_txn *txn = null;
    MDB_cursor *cursor = null;
    if ((rc = mdb_txn_begin(env, null, 0, &txn)) != 0)
    {
        err = mdb_strerror(rc);
        writeln(format("%s (%s)", err, "data_dir"));
        return false;
    }
    if ((rc = mdb_cursor_open(txn, db_txindexes, &cursor)) != 0)
    {
        err = mdb_strerror(rc);
        writeln(format("%s (%s)", err, "data_dir"));
        mdb_txn_abort(txn);
        return false;
    }

    MDB_cursor_op op = MDB_cursor_op.MDB_FIRST;

    while (1)
    {
        MDB_val key;
        MDB_val val;
        rc = mdb_cursor_get(cursor, &key, &val, op);

        op = MDB_cursor_op.MDB_NEXT;
        if (rc != 0)
        {
            break;
        }

       
        TxIndex index = cast(TxIndex*)val.mv_data;

        Uint256 hash = new Uint256();
        // convert the transaction hash from string to uint256.
        hash.SetHex(cast(string)index.nTxHash);


        // update memory.
        mapTxIndex[hash] = index; 
        
        //writeln(format("%s added to mapTxIndex", index.nTxHash));
    }


    // clear 
    mdb_cursor_close(cursor);
    mdb_txn_abort(txn);

    return true;
}