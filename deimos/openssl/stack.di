/* crypto/stack/stack.h */
/* Copyright (C) 1995-1998 Eric Young (eay@cryptsoft.com)
 * All rights reserved.
 *
 * This package is an SSL implementation written
 * by Eric Young (eay@cryptsoft.com).
 * The implementation was written so as to conform with Netscapes SSL.
 *
 * This library is free for commercial and non-commercial use as long as
 * the following conditions are aheared to.  The following conditions
 * apply to all code found in this distribution, be it the RC4, RSA,
 * lhash, DES, etc., code; not just the SSL code.  The SSL documentation
 * included with this distribution is covered by the same copyright terms
 * except that the holder is Tim Hudson (tjh@cryptsoft.com).
 *
 * Copyright remains Eric Young's, and as such any Copyright notices in
 * the code are not to be removed.
 * If this package is used in a product, Eric Young should be given attribution
 * as the author of the parts of the library used.
 * This can be in the form of a textual message at program startup or
 * in documentation (online or textual) provided with the package.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the copyright
 *   notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *   must display the following acknowledgement:
 *   "This product includes cryptographic software written by
 *    Eric Young (eay@cryptsoft.com)"
 *   The word 'cryptographic' can be left out if the rouines from the library
 *   being used are not cryptographic related :-).
 * 4. If you include any Windows specific code (or a derivative thereof) from
 *   the apps directory (application code) you must include an acknowledgement:
 *   "This product includes software written by Tim Hudson (tjh@cryptsoft.com)"
 *
 * THIS SOFTWARE IS PROVIDED BY ERIC YOUNG ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * The licence and distribution terms for any publically available version or
 * derivative of this code cannot be changed.  i.e. this code cannot simply be
 * copied and put under another distribution licence
 * [including the GNU Public Licence.]
 */

module deimos.openssl.stack;

import deimos.openssl._d_util;
import deimos.openssl.opensslv;

extern (C):
nothrow:

struct stack_st {
	int num;
	char** data;
	int sorted;

	int num_alloc;
	ExternC!(int function(const(void)*, const(void)*)) comp;
	}
alias stack_st _STACK;  /* Use STACK_OF(...) instead */

int M_sk_num()(_STACK* sk) { return (sk ? sk.num : -1); }
char* M_sk_value()(_STACK* sk, size_t n) { return (sk ? sk.data[n] : null); }

/*******************************************************************************

    Starting from OpenSSL v1.1.0, the `sk_*` functions are prefixed with
    `OPENSSL_`, so e.g. `sk_num` becomes `OPENSSL_sk_num`.

    To cope with that and provide downstream with an easier interface to deal
    with, we always provide the `OPENSSL_` methods, as they are just `extern(C)`
    anyway, and we either provide `sk_*` as `alias`es or `extern (C)`.

    The need for aliases comes from users of those binding, e.g. `safestack`.

*******************************************************************************/

static if (OPENSSL_VERSION_AT_LEAST(1, 1))
{
    int OPENSSL_sk_num(const(_STACK)*);
    void* OPENSSL_sk_value(const(_STACK)*, int);

    void* OPENSSL_sk_set(_STACK*, int, void*);

    _STACK* OPENSSL_sk_new(ExternC!(int function(const(void)*, const(void)*)) cmp);
    _STACK* OPENSSL_sk_new_null();
    void OPENSSL_sk_free(_STACK*);
    void OPENSSL_sk_pop_free(_STACK* st, ExternC!(void function(void*)) func);
    int OPENSSL_sk_insert(_STACK* sk, void* data, int where);
    void* OPENSSL_sk_delete(_STACK* st, int loc);
    void* OPENSSL_sk_delete_ptr(_STACK* st, void* p);
    int OPENSSL_sk_find(_STACK* st, void* data);
    int OPENSSL_sk_find_ex(_STACK* st, void* data);
    int OPENSSL_sk_push(_STACK* st, void* data);
    int OPENSSL_sk_unshift(_STACK* st, void* data);
    void* OPENSSL_sk_shift(_STACK* st);
    void* OPENSSL_sk_pop(_STACK* st);
    void OPENSSL_sk_zero(_STACK* st);
    int function(const(void)*, const(void)*) OPENSSL_sk_set_cmp_func(_STACK* sk, ExternC!(int function(const(void)*, const(void)*)) c);
    _STACK* OPENSSL_sk_dup(_STACK* st);
    void OPENSSL_sk_sort(_STACK* st);
    int OPENSSL_sk_is_sorted(const(_STACK)* st);

    alias sk_num = OPENSSL_sk_num;
    alias sk_value = OPENSSL_sk_value;
    alias sk_set = OPENSSL_sk_set;

    alias sk_new = OPENSSL_sk_new;
    alias sk_new_null = OPENSSL_sk_new_null;
    alias sk_free = OPENSSL_sk_free;
    alias sk_pop_free = OPENSSL_sk_pop_free;
    alias sk_insert = OPENSSL_sk_insert;
    alias sk_delete = OPENSSL_sk_delete;
    alias sk_delete_ptr = OPENSSL_sk_delete_ptr;
    alias sk_find = OPENSSL_sk_find;
    alias sk_find_ex = OPENSSL_sk_find_ex;

    alias sk_push = OPENSSL_sk_push;
    alias sk_unshift = OPENSSL_sk_unshift;
    alias sk_shift = OPENSSL_sk_shift;
    alias sk_pop = OPENSSL_sk_pop;
    alias sk_zero = OPENSSL_sk_zero;
    alias sk_set_cmp_func = OPENSSL_sk_set_cmp_func;
    alias sk_dup = OPENSSL_sk_dup;
    alias sk_sort = OPENSSL_sk_sort;
    alias sk_is_sorted = OPENSSL_sk_is_sorted;
}
else
{
    int sk_num(const(_STACK)*);
    void* sk_value(const(_STACK)*, int);

    void* sk_set(_STACK*, int, void*);

    _STACK* sk_new(ExternC!(int function(const(void)*, const(void)*)) cmp);
    _STACK* sk_new_null();
    void sk_free(_STACK*);
    void sk_pop_free(_STACK* st, ExternC!(void function(void*)) func);
    int sk_insert(_STACK* sk, void* data, int where);
    void* sk_delete(_STACK* st, int loc);
    void* sk_delete_ptr(_STACK* st, void* p);
    int sk_find(_STACK* st, void* data);
    int sk_find_ex(_STACK* st, void* data);
    int sk_push(_STACK* st, void* data);
    int sk_unshift(_STACK* st, void* data);
    void* sk_shift(_STACK* st);
    void* sk_pop(_STACK* st);
    void sk_zero(_STACK* st);
    int function(const(void)*, const(void)*) sk_set_cmp_func(_STACK* sk, ExternC!(int function(const(void)*, const(void)*)) c);
    _STACK* sk_dup(_STACK* st);
    void sk_sort(_STACK* st);
    int sk_is_sorted(const(_STACK)* st);

    // Forward-compatible aliases, so one can use OpenSSL v1.1.0 API
    // while keeping v1.0.x compatibility
    alias OPENSSL_sk_num = sk_num;
    alias OPENSSL_sk_value = sk_value;
    alias OPENSSL_sk_set = sk_set;

    alias OPENSSL_sk_new = sk_new;
    alias OPENSSL_sk_new_null = sk_new_null;
    alias OPENSSL_sk_free = sk_free;
    alias OPENSSL_sk_pop_free = sk_pop_free;
    alias OPENSSL_sk_insert = sk_insert;
    alias OPENSSL_sk_delete = sk_delete;
    alias OPENSSL_sk_delete_ptr = sk_delete_ptr;
    alias OPENSSL_sk_find = sk_find;
    alias OPENSSL_sk_find_ex = sk_find_ex;

    alias OPENSSL_sk_push = sk_push;
    alias OPENSSL_sk_unshift = sk_unshift;
    alias OPENSSL_sk_shift = sk_shift;
    alias OPENSSL_sk_pop = sk_pop;
    alias OPENSSL_sk_zero = sk_zero;
    alias OPENSSL_sk_set_cmp_func = sk_set_cmp_func;
    alias OPENSSL_sk_dup = sk_dup;
    alias OPENSSL_sk_sort = sk_sort;
    alias OPENSSL_sk_is_sorted = sk_is_sorted;
}
