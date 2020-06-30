/*	$FreeBSD$	*/
/*	$OpenBSD: cryptodev.h,v 1.31 2002/06/11 11:14:29 beck Exp $	*/

/*-
 * The author of this code is Angelos D. Keromytis (angelos@cis.upenn.edu)
 * Copyright (c) 2002-2006 Sam Leffler, Errno Consulting
 *
 * This code was written by Angelos D. Keromytis in Athens, Greece, in
 * February 2000. Network Security Technologies Inc. (NSTI) kindly
 * supported the development of this code.
 *
 * Copyright (c) 2000 Angelos D. Keromytis
 *
 * Permission to use, copy, and modify this software with or without fee
 * is hereby granted, provided that this entire notice is included in
 * all source code copies of any software which is or includes a copy or
 * modification of this software.
 *
 * THIS SOFTWARE IS BEING PROVIDED "AS IS", WITHOUT ANY EXPRESS OR
 * IMPLIED WARRANTY. IN PARTICULAR, NONE OF THE AUTHORS MAKES ANY
 * REPRESENTATION OR WARRANTY OF ANY KIND CONCERNING THE
 * MERCHANTABILITY OF THIS SOFTWARE OR ITS FITNESS FOR ANY PARTICULAR
 * PURPOSE.
 *
 * Copyright (c) 2001 Theo de Raadt
 * Copyright (c) 2014 The FreeBSD Foundation
 * All rights reserved.
 *
 * Portions of this software were developed by John-Mark Gurney
 * under sponsorship of the FreeBSD Foundation and
 * Rubicon Communications, LLC (Netgate).
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *   derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Effort sponsored in part by the Defense Advanced Research Projects
 * Agency (DARPA) and Air Force Research Laboratory, Air Force
 * Materiel Command, USAF, under agreement number F30602-01-2-0537.
 *
 */

#ifndef _CRYPTO_CRYPTO_H_
#define _CRYPTO_CRYPTO_H_

#include <sys/ioccom.h>
#include <sys/_iovec.h>

#ifdef _KERNEL
#include <opencrypto/_cryptodev.h>
#include <sys/_task.h>
#endif

/* Some initial values */
#define CRYPTO_DRIVERS_INITIAL	4

/* Hash values */
#define	NULL_HASH_LEN		16
#define	SHA1_HASH_LEN		20
#define	RIPEMD160_HASH_LEN	20
#define	SHA2_224_HASH_LEN	28
#define	SHA2_256_HASH_LEN	32
#define	SHA2_384_HASH_LEN	48
#define	SHA2_512_HASH_LEN	64
#define	AES_GMAC_HASH_LEN	16
#define	POLY1305_HASH_LEN	16
#define	AES_CBC_MAC_HASH_LEN	16
/* Maximum hash algorithm result length */
#define	HASH_MAX_LEN		SHA2_512_HASH_LEN /* Keep this updated */

#define	SHA1_BLOCK_LEN		64
#define	RIPEMD160_BLOCK_LEN	64
#define	SHA2_224_BLOCK_LEN	64
#define	SHA2_256_BLOCK_LEN	64
#define	SHA2_384_BLOCK_LEN	128
#define	SHA2_512_BLOCK_LEN	128

/* HMAC values */
#define	NULL_HMAC_BLOCK_LEN		64
/* Maximum HMAC block length */
#define	HMAC_MAX_BLOCK_LEN	SHA2_512_BLOCK_LEN /* Keep this updated */
#define	HMAC_IPAD_VAL			0x36
#define	HMAC_OPAD_VAL			0x5C
/* HMAC Key Length */
#define	AES_128_GMAC_KEY_LEN		16
#define	AES_192_GMAC_KEY_LEN		24
#define	AES_256_GMAC_KEY_LEN		32
#define	AES_128_CBC_MAC_KEY_LEN		16
#define	AES_192_CBC_MAC_KEY_LEN		24
#define	AES_256_CBC_MAC_KEY_LEN		32

#define	POLY1305_KEY_LEN		32

/* Encryption algorithm block sizes */
#define	NULL_BLOCK_LEN		4	/* IPsec to maintain alignment */
#define	RIJNDAEL128_BLOCK_LEN	16
#define	AES_BLOCK_LEN		16
#define	AES_ICM_BLOCK_LEN	1
#define	CAMELLIA_BLOCK_LEN	16
#define	CHACHA20_NATIVE_BLOCK_LEN	64
#define	EALG_MAX_BLOCK_LEN	CHACHA20_NATIVE_BLOCK_LEN /* Keep this updated */

/* IV Lengths */

#define	AES_GCM_IV_LEN		12
#define	AES_CCM_IV_LEN		12
#define	AES_XTS_IV_LEN		8
#define	AES_XTS_ALPHA		0x87	/* GF(2^128) generator polynomial */

/* Min and Max Encryption Key Sizes */
#define	NULL_MIN_KEY		0
#define	NULL_MAX_KEY		256 /* 2048 bits, max key */
#define	RIJNDAEL_MIN_KEY	16
#define	RIJNDAEL_MAX_KEY	32
#define	AES_MIN_KEY		RIJNDAEL_MIN_KEY
#define	AES_MAX_KEY		RIJNDAEL_MAX_KEY
#define	AES_XTS_MIN_KEY		(2 * AES_MIN_KEY)
#define	AES_XTS_MAX_KEY		(2 * AES_MAX_KEY)
#define	CAMELLIA_MIN_KEY	16
#define	CAMELLIA_MAX_KEY	32

/* Maximum hash algorithm result length */
#define	AALG_MAX_RESULT_LEN	64 /* Keep this updated */

#define	CRYPTO_ALGORITHM_MIN	1
#define	CRYPTO_DES_CBC		1
#define	CRYPTO_3DES_CBC		2
#define	CRYPTO_BLF_CBC		3
#define	CRYPTO_CAST_CBC		4
#define	CRYPTO_SKIPJACK_CBC	5
#define	CRYPTO_MD5_HMAC		6
#define	CRYPTO_SHA1_HMAC	7
#define	CRYPTO_RIPEMD160_HMAC	8
#define	CRYPTO_MD5_KPDK		9
#define	CRYPTO_SHA1_KPDK	10
#define	CRYPTO_RIJNDAEL128_CBC	11 /* 128 bit blocksize */
#define	CRYPTO_AES_CBC		11 /* 128 bit blocksize -- the same as above */
#define	CRYPTO_ARC4		12
#define	CRYPTO_MD5		13
#define	CRYPTO_SHA1		14
#define	CRYPTO_NULL_HMAC	15
#define	CRYPTO_NULL_CBC		16
#define	CRYPTO_DEFLATE_COMP	17 /* Deflate compression algorithm */
#define	CRYPTO_SHA2_256_HMAC	18
#define	CRYPTO_SHA2_384_HMAC	19
#define	CRYPTO_SHA2_512_HMAC	20
#define	CRYPTO_CAMELLIA_CBC	21
#define	CRYPTO_AES_XTS		22
#define	CRYPTO_AES_ICM		23 /* commonly known as CTR mode */
#define	CRYPTO_AES_NIST_GMAC	24 /* GMAC only */
#define	CRYPTO_AES_NIST_GCM_16	25 /* 16 byte ICV */
#ifdef _KERNEL
#define	CRYPTO_AES_128_NIST_GMAC 26 /* auth side */
#define	CRYPTO_AES_192_NIST_GMAC 27 /* auth side */
#define	CRYPTO_AES_256_NIST_GMAC 28 /* auth side */
#endif
#define	CRYPTO_BLAKE2B		29 /* Blake2b hash */
#define	CRYPTO_BLAKE2S		30 /* Blake2s hash */
#define	CRYPTO_CHACHA20		31 /* Chacha20 stream cipher */
#define	CRYPTO_SHA2_224_HMAC	32
#define	CRYPTO_RIPEMD160	33
#define	CRYPTO_SHA2_224		34
#define	CRYPTO_SHA2_256		35
#define	CRYPTO_SHA2_384		36
#define	CRYPTO_SHA2_512		37
#define	CRYPTO_POLY1305		38
#define	CRYPTO_AES_CCM_CBC_MAC	39	/* auth side */
#define	CRYPTO_AES_CCM_16	40	/* cipher side */
#define	CRYPTO_ALGORITHM_MAX	40	/* Keep updated - see below */

#define	CRYPTO_ALGO_VALID(x)	((x) >= CRYPTO_ALGORITHM_MIN && \
				 (x) <= CRYPTO_ALGORITHM_MAX)

/* Algorithm flags */
#define	CRYPTO_ALG_FLAG_SUPPORTED	0x01 /* Algorithm is supported */
#define	CRYPTO_ALG_FLAG_RNG_ENABLE	0x02 /* Has HW RNG for DH/DSA */
#define	CRYPTO_ALG_FLAG_DSA_SHA		0x04 /* Can do SHA on msg */

/*
 * Crypto driver/device flags.  They can set in the crid
 * parameter when creating a session or submitting a key
 * op to affect the device/driver assigned.  If neither
 * of these are specified then the crid is assumed to hold
 * the driver id of an existing (and suitable) device that
 * must be used to satisfy the request.
 */
#define CRYPTO_FLAG_HARDWARE	0x01000000	/* hardware accelerated */
#define CRYPTO_FLAG_SOFTWARE	0x02000000	/* software implementation */

/* NB: deprecated */
struct session_op {
	u_int32_t	cipher;		/* ie. CRYPTO_AES_CBC */
	u_int32_t	mac;		/* ie. CRYPTO_SHA2_256_HMAC */

	u_int32_t	keylen;		/* cipher key */
	const char * __kerncap key;
	int		mackeylen;	/* mac key */
	const char * __kerncap mackey;

  	u_int32_t	ses;		/* returns: session # */ 
};

/*
 * session and crypt _op structs are used by userspace programs to interact
 * with /dev/crypto.  Confusingly, the internal kernel interface is named
 * "cryptop" (no underscore).
 */
struct session2_op {
	u_int32_t	cipher;		/* ie. CRYPTO_AES_CBC */
	u_int32_t	mac;		/* ie. CRYPTO_SHA2_256_HMAC */

	u_int32_t	keylen;		/* cipher key */
	const char * __kerncap key;
	int		mackeylen;	/* mac key */
	const char * __kerncap mackey;

  	u_int32_t	ses;		/* returns: session # */ 
	int		crid;		/* driver id + flags (rw) */
	int		pad[4];		/* for future expansion */
};

struct crypt_op {
	u_int32_t	ses;
	u_int16_t	op;		/* i.e. COP_ENCRYPT */
#define COP_ENCRYPT	1
#define COP_DECRYPT	2
	u_int16_t	flags;
#define	COP_F_CIPHER_FIRST	0x0001	/* Cipher before MAC. */
#define	COP_F_BATCH		0x0008	/* Batch op if possible */
	u_int		len;
	const char * __kerncap src;	/* become iov[] inside kernel */
	char * __kerncap dst;
	char * __kerncap mac;		/* must be big enough for chosen MAC */
	const char * __kerncap iv;
};

/* op and flags the same as crypt_op */
struct crypt_aead {
	u_int32_t	ses;
	u_int16_t	op;		/* i.e. COP_ENCRYPT */
	u_int16_t	flags;
	u_int		len;
	u_int		aadlen;
	u_int		ivlen;
	const char * __kerncap src;	/* become iov[] inside kernel */
	char * __kerncap dst;
	const char * __kerncap aad;	/* additional authenticated data */
	char * __kerncap tag;		/* must fit for chosen TAG length */
	const char * __kerncap iv;
};

/*
 * Parameters for looking up a crypto driver/device by
 * device name or by id.  The latter are returned for
 * created sessions (crid) and completed key operations.
 */
struct crypt_find_op {
	int		crid;		/* driver id + flags */
	char		name[32];	/* device/driver name */
};

/* bignum parameter, in packed bytes, ... */
struct crparam {
	union {
#ifdef _KERNEL
		char * __capability crp_up;
#endif
		caddr_t	crp_p;
	};
	u_int		crp_nbits;
};

#define CRK_MAXPARAM	8

struct crypt_kop {
	u_int		crk_op;		/* ie. CRK_MOD_EXP or other */
	u_int		crk_status;	/* return status */
	u_short		crk_iparams;	/* # of input parameters */
	u_short		crk_oparams;	/* # of output parameters */
	u_int		crk_crid;	/* NB: only used by CIOCKEY2 (rw) */
	struct crparam	crk_param[CRK_MAXPARAM];
};
#define	CRK_ALGORITM_MIN	0
#define CRK_MOD_EXP		0
#define CRK_MOD_EXP_CRT		1
#define CRK_DSA_SIGN		2
#define CRK_DSA_VERIFY		3
#define CRK_DH_COMPUTE_KEY	4
#define CRK_ALGORITHM_MAX	4 /* Keep updated - see below */

#define CRF_MOD_EXP		(1 << CRK_MOD_EXP)
#define CRF_MOD_EXP_CRT		(1 << CRK_MOD_EXP_CRT)
#define CRF_DSA_SIGN		(1 << CRK_DSA_SIGN)
#define CRF_DSA_VERIFY		(1 << CRK_DSA_VERIFY)
#define CRF_DH_COMPUTE_KEY	(1 << CRK_DH_COMPUTE_KEY)

/*
 * done against open of /dev/crypto, to get a cloned descriptor.
 * Please use F_SETFD against the cloned descriptor.
 */
#define	CRIOGET		_IOWR('c', 100, u_int32_t)
#define	CRIOASYMFEAT	CIOCASYMFEAT
#define	CRIOFINDDEV	CIOCFINDDEV

/* the following are done against the cloned descriptor */
#define	CIOCGSESSION	_IOWR('c', 101, struct session_op)
#define	CIOCFSESSION	_IOW('c', 102, u_int32_t)
#define CIOCCRYPT	_IOWR('c', 103, struct crypt_op)
#define CIOCKEY		_IOWR('c', 104, struct crypt_kop)
#define CIOCASYMFEAT	_IOR('c', 105, u_int32_t)
#define	CIOCGSESSION2	_IOWR('c', 106, struct session2_op)
#define	CIOCKEY2	_IOWR('c', 107, struct crypt_kop)
#define	CIOCFINDDEV	_IOWR('c', 108, struct crypt_find_op)
#define	CIOCCRYPTAEAD	_IOWR('c', 109, struct crypt_aead)

struct cryptostats {
	u_int32_t	cs_ops;		/* symmetric crypto ops submitted */
	u_int32_t	cs_errs;	/* symmetric crypto ops that failed */
	u_int32_t	cs_kops;	/* asymetric/key ops submitted */
	u_int32_t	cs_kerrs;	/* asymetric/key ops that failed */
	u_int32_t	cs_intrs;	/* crypto swi thread activations */
	u_int32_t	cs_rets;	/* crypto return thread activations */
	u_int32_t	cs_blocks;	/* symmetric op driver block */
	u_int32_t	cs_kblocks;	/* symmetric op driver block */
};

#ifdef _KERNEL

/*
 * Return values for cryptodev_probesession methods.
 */
#define	CRYPTODEV_PROBE_HARDWARE	(-100)
#define	CRYPTODEV_PROBE_ACCEL_SOFTWARE	(-200)
#define	CRYPTODEV_PROBE_SOFTWARE	(-500)

#if 0
#define CRYPTDEB(s, ...) do {						\
	printf("%s:%d: " s "\n", __FILE__, __LINE__, ## __VA_ARGS__);	\
} while (0)
#else
#define CRYPTDEB(...)	do { } while (0)
#endif

struct crypto_session_params {
	int		csp_mode;	/* Type of operations to perform. */

#define	CSP_MODE_NONE		0
#define	CSP_MODE_COMPRESS	1	/* Compression/decompression. */
#define	CSP_MODE_CIPHER		2	/* Encrypt/decrypt. */
#define	CSP_MODE_DIGEST		3	/* Compute/verify digest. */
#define	CSP_MODE_AEAD		4	/* Combined auth/encryption. */
#define	CSP_MODE_ETA		5	/* IPsec style encrypt-then-auth */

	int		csp_flags;

#define	CSP_F_SEPARATE_OUTPUT	0x0001	/* Requests can use separate output */
#define	CSP_F_SEPARATE_AAD	0x0002	/* Requests can use separate AAD */

	int		csp_ivlen;	/* IV length in bytes. */

	int		csp_cipher_alg;
	int		csp_cipher_klen; /* Key length in bytes. */
	const void	*csp_cipher_key;

	int		csp_auth_alg;
	int		csp_auth_klen;	/* Key length in bytes. */
	const void	*csp_auth_key;
	int		csp_auth_mlen;	/* Number of digest bytes to use.
					   0 means all. */
};

enum crypto_buffer_type {
	CRYPTO_BUF_NONE = 0,
	CRYPTO_BUF_CONTIG,
	CRYPTO_BUF_UIO,
	CRYPTO_BUF_MBUF,
	CRYPTO_BUF_LAST = CRYPTO_BUF_MBUF
};

/*
 * Description of a data buffer for a request.  Requests can either
 * have a single buffer that is modified in place or separate input
 * and output buffers.
 */
struct crypto_buffer {
	union {
		struct {
			char	*cb_buf;
			int	cb_buf_len;
		};
		struct mbuf *cb_mbuf;
		struct uio *cb_uio;
	};
	enum crypto_buffer_type cb_type;
};

/*
 * A cursor is used to iterate through a crypto request data buffer.
 */
struct crypto_buffer_cursor {
	union {
		char *cc_buf;
		struct mbuf *cc_mbuf;
		struct iovec *cc_iov;
	};
	union {
		int cc_buf_len;
		size_t cc_offset;
	};
	enum crypto_buffer_type cc_type;
};

/* Structure describing complete operation */
struct cryptop {
	TAILQ_ENTRY(cryptop) crp_next;

	struct task	crp_task;

	crypto_session_t crp_session;	/* Session */
	int		crp_olen;	/* Result total length */

	int		crp_etype;	/*
					 * Error type (zero means no error).
					 * All error codes except EAGAIN
					 * indicate possible data corruption (as in,
					 * the data have been touched). On all
					 * errors, the crp_session may have changed
					 * (reset to a new one), so the caller
					 * should always check and use the new
					 * value on future requests.
					 */
	int		crp_flags;

#define	CRYPTO_F_BATCH		0x0008	/* Batch op if possible */
#define	CRYPTO_F_CBIMM		0x0010	/* Do callback immediately */
#define	CRYPTO_F_DONE		0x0020	/* Operation completed */
#define	CRYPTO_F_CBIFSYNC	0x0040	/* Do CBIMM if op is synchronous */
#define	CRYPTO_F_ASYNC		0x0080	/* Dispatch crypto jobs on several threads
					 * if op is synchronous
					 */
#define	CRYPTO_F_ASYNC_KEEPORDER	0x0100	/*
					 * Dispatch the crypto jobs in the same
					 * order there are submitted. Applied only
					 * if CRYPTO_F_ASYNC flags is set
					 */
#define	CRYPTO_F_IV_SEPARATE	0x0200	/* Use crp_iv[] as IV. */

	int		crp_op;

	struct crypto_buffer crp_buf;
	struct crypto_buffer crp_obuf;

	void		*crp_aad;	/* AAD buffer. */
	int		crp_aad_start;	/* Location of AAD. */
	int		crp_aad_length;	/* 0 => no AAD. */
	int		crp_iv_start;	/* Location of IV.  IV length is from
					 * the session.
					 */
	int		crp_payload_start; /* Location of ciphertext. */
	int		crp_payload_output_start;
	int		crp_payload_length;
	int		crp_digest_start; /* Location of MAC/tag.  Length is
					   * from the session.
					   */

	uint8_t		crp_iv[EALG_MAX_BLOCK_LEN]; /* IV if IV_SEPARATE. */

	const void	*crp_cipher_key; /* New cipher key if non-NULL. */
	const void	*crp_auth_key;	/* New auth key if non-NULL. */

	void		*crp_opaque;	/* Opaque pointer, passed along */

	int (*crp_callback)(struct cryptop *); /* Callback function */

	struct bintime	crp_tstamp;	/* performance time stamp */
	uint32_t	crp_seq;	/* used for ordered dispatch */
	uint32_t	crp_retw_id;	/*
					 * the return worker to be used,
					 *  used for ordered dispatch
					 */
};

static __inline void
_crypto_use_buf(struct crypto_buffer *cb, void *buf, int len)
{
	cb->cb_buf = buf;
	cb->cb_buf_len = len;
	cb->cb_type = CRYPTO_BUF_CONTIG;
}

static __inline void
_crypto_use_mbuf(struct crypto_buffer *cb, struct mbuf *m)
{
	cb->cb_mbuf = m;
	cb->cb_type = CRYPTO_BUF_MBUF;
}

static __inline void
_crypto_use_uio(struct crypto_buffer *cb, struct uio *uio)
{
	cb->cb_uio = uio;
	cb->cb_type = CRYPTO_BUF_UIO;
}

static __inline void
crypto_use_buf(struct cryptop *crp, void *buf, int len)
{
	_crypto_use_buf(&crp->crp_buf, buf, len);
}

static __inline void
crypto_use_mbuf(struct cryptop *crp, struct mbuf *m)
{
	_crypto_use_mbuf(&crp->crp_buf, m);
}

static __inline void
crypto_use_uio(struct cryptop *crp, struct uio *uio)
{
	_crypto_use_uio(&crp->crp_buf, uio);
}

static __inline void
crypto_use_output_buf(struct cryptop *crp, void *buf, int len)
{
	_crypto_use_buf(&crp->crp_obuf, buf, len);
}

static __inline void
crypto_use_output_mbuf(struct cryptop *crp, struct mbuf *m)
{
	_crypto_use_mbuf(&crp->crp_obuf, m);
}

static __inline void
crypto_use_output_uio(struct cryptop *crp, struct uio *uio)
{
	_crypto_use_uio(&crp->crp_obuf, uio);
}

#define	CRYPTOP_ASYNC(crp)			\
	(((crp)->crp_flags & CRYPTO_F_ASYNC) && \
	crypto_ses2caps((crp)->crp_session) & CRYPTOCAP_F_SYNC)
#define	CRYPTOP_ASYNC_KEEPORDER(crp) \
	(CRYPTOP_ASYNC(crp) && \
	(crp)->crp_flags & CRYPTO_F_ASYNC_KEEPORDER)
#define	CRYPTO_HAS_OUTPUT_BUFFER(crp)					\
	((crp)->crp_obuf.cb_type != CRYPTO_BUF_NONE)

/* Flags in crp_op. */
#define	CRYPTO_OP_DECRYPT		0x0
#define	CRYPTO_OP_ENCRYPT		0x1
#define	CRYPTO_OP_IS_ENCRYPT(op)	((op) & CRYPTO_OP_ENCRYPT)
#define	CRYPTO_OP_COMPUTE_DIGEST	0x0
#define	CRYPTO_OP_VERIFY_DIGEST		0x2
#define	CRYPTO_OP_DECOMPRESS		CRYPTO_OP_DECRYPT
#define	CRYPTO_OP_COMPRESS		CRYPTO_OP_ENCRYPT
#define	CRYPTO_OP_IS_COMPRESS(op)	((op) & CRYPTO_OP_COMPRESS)

/*
 * Hints passed to process methods.
 */
#define	CRYPTO_HINT_MORE	0x1	/* more ops coming shortly */

struct cryptkop {
	TAILQ_ENTRY(cryptkop) krp_next;

	u_int		krp_op;		/* ie. CRK_MOD_EXP or other */
	u_int		krp_status;	/* return status */
	u_short		krp_iparams;	/* # of input parameters */
	u_short		krp_oparams;	/* # of output parameters */
	u_int		krp_crid;	/* desired device, etc. */
	uint32_t	krp_hid;	/* device used */
	struct crparam	krp_param[CRK_MAXPARAM];	/* kvm */
	void		(*krp_callback)(struct cryptkop *);
	struct cryptocap *krp_cap;
};

uint32_t crypto_ses2hid(crypto_session_t crypto_session);
uint32_t crypto_ses2caps(crypto_session_t crypto_session);
void *crypto_get_driver_session(crypto_session_t crypto_session);
const struct crypto_session_params *crypto_get_params(
    crypto_session_t crypto_session);
struct auth_hash *crypto_auth_hash(const struct crypto_session_params *csp);
struct enc_xform *crypto_cipher(const struct crypto_session_params *csp);

MALLOC_DECLARE(M_CRYPTO_DATA);

extern	int crypto_newsession(crypto_session_t *cses,
    const struct crypto_session_params *params, int hard);
extern	void crypto_freesession(crypto_session_t cses);
#define	CRYPTOCAP_F_HARDWARE	CRYPTO_FLAG_HARDWARE
#define	CRYPTOCAP_F_SOFTWARE	CRYPTO_FLAG_SOFTWARE
#define	CRYPTOCAP_F_SYNC	0x04000000	/* operates synchronously */
#define	CRYPTOCAP_F_ACCEL_SOFTWARE 0x08000000
extern	int32_t crypto_get_driverid(device_t dev, size_t session_size,
    int flags);
extern	int crypto_find_driver(const char *);
extern	device_t crypto_find_device_byhid(int hid);
extern	int crypto_getcaps(int hid);
extern	int crypto_kregister(u_int32_t, int, u_int32_t);
extern	int crypto_unregister_all(u_int32_t driverid);
extern	int crypto_dispatch(struct cryptop *crp);
extern	int crypto_kdispatch(struct cryptkop *);
#define	CRYPTO_SYMQ	0x1
#define	CRYPTO_ASYMQ	0x2
extern	int crypto_unblock(u_int32_t, int);
extern	void crypto_done(struct cryptop *crp);
extern	void crypto_kdone(struct cryptkop *);
extern	int crypto_getfeat(int *);

extern	void crypto_freereq(struct cryptop *crp);
extern	struct cryptop *crypto_getreq(crypto_session_t cses, int how);

extern	int crypto_usercrypto;		/* userland may do crypto requests */
extern	int crypto_userasymcrypto;	/* userland may do asym crypto reqs */
extern	int crypto_devallowsoft;	/* only use hardware crypto */

#ifdef SYSCTL_DECL
SYSCTL_DECL(_kern_crypto);
#endif

/* Helper routines for drivers to initialize auth contexts for HMAC. */
struct auth_hash;

void	hmac_init_ipad(struct auth_hash *axf, const char *key, int klen,
    void *auth_ctx);
void	hmac_init_opad(struct auth_hash *axf, const char *key, int klen,
    void *auth_ctx);

/*
 * Crypto-related utility routines used mainly by drivers.
 *
 * Similar to m_copyback/data, *_copyback copy data from the 'src'
 * buffer into the crypto request's data buffer while *_copydata copy
 * data from the crypto request's data buffer into the the 'dst'
 * buffer.
 */
void	crypto_copyback(struct cryptop *crp, int off, int size,
	    const void *src);
void	crypto_copydata(struct cryptop *crp, int off, int size, void *dst);
int	crypto_apply(struct cryptop *crp, int off, int len,
	    int (*f)(void *, const void *, u_int), void *arg);
void	*crypto_contiguous_subsegment(struct cryptop *crp, size_t skip,
	    size_t len);

int	crypto_apply_buf(struct crypto_buffer *cb, int off, int len,
	    int (*f)(void *, const void *, u_int), void *arg);
void	*crypto_buffer_contiguous_subsegment(struct crypto_buffer *cb,
	    size_t skip, size_t len);
size_t	crypto_buffer_len(struct crypto_buffer *cb);
void	crypto_cursor_init(struct crypto_buffer_cursor *cc,
	    const struct crypto_buffer *cb);
void	crypto_cursor_advance(struct crypto_buffer_cursor *cc, size_t amount);
void	*crypto_cursor_segbase(struct crypto_buffer_cursor *cc);
size_t	crypto_cursor_seglen(struct crypto_buffer_cursor *cc);
void	crypto_cursor_copyback(struct crypto_buffer_cursor *cc, int size,
	    const void *vsrc);
void	crypto_cursor_copydata(struct crypto_buffer_cursor *cc, int size,
	    void *vdst);
void	crypto_cursor_copydata_noadv(struct crypto_buffer_cursor *cc, int size,
	    void *vdst);

static __inline void
crypto_read_iv(struct cryptop *crp, void *iv)
{
	const struct crypto_session_params *csp;

	csp = crypto_get_params(crp->crp_session);
	if (crp->crp_flags & CRYPTO_F_IV_SEPARATE)
		memcpy(iv, crp->crp_iv, csp->csp_ivlen);
	else
		crypto_copydata(crp, crp->crp_iv_start, csp->csp_ivlen, iv);
}

#endif /* _KERNEL */
#endif /* _CRYPTO_CRYPTO_H_ */
