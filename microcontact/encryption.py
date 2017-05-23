from os import urandom
# os.urandom is used for generation of random bytes. 
# Ok for cryptographic use, see https://docs.python.org/3.4/library/os.html
from hashlib import pbkdf2_hmac
# dependencies on package pycrypto
from Crypto.Cipher import AES
from Crypto.Random import random
from Crypto.Util import Counter

def derive_key(password, salt, key_length):
    '''
    Given a secret password and salt, this function generates a key,
    based on the password.
    hashlib's pbkdf is a recommended key derivation function
    See:
    https://docs.python.org/3/library/hashlib.html
    '''
    key = pbkdf2_hmac('sha256', password, salt, 100000, key_length)
    return key

def create_counter(iv, bs):
    '''
    Given an initial value (iv), a counter object is created,
    Using the Crypto Counter class
    This is needed for the AES counter block cipher
    '''
    iv = int.from_bytes(iv, 'big')
    ctr = Counter.new(8 * bs, initial_value = iv)
    return ctr

def encrypt(in_file, out_file, password, key_length=32):
    '''
    Given an input file and an output file and a secret password,
    generates a salt and initial value (iv) for the AES encryption,
    which are written to the encrypted file.
    AES.MODE_CTR means that AES encryption takes place in "Counter" mode.
    Then, for chunks, of 1024 * 16 (AES.block_size) bits,
    an input file is encoded and written to out_file.
    If the last chunk is smaller than the block size, it is padded
    The padding_length is written into this padded part of the file.
    '''
    bs = AES.block_size
    salt = urandom(bs)
    key = derive_key(password, salt, key_length)
    iv = urandom(bs)
    ctr = create_counter(iv, bs)
    cipher = AES.new(key, AES.MODE_CTR, counter=ctr)
    out_file.write(salt + iv)
    finished = False
    while not finished:
        chunk = in_file.read(1024 * bs) 
        if len(chunk) == 0 or len(chunk) % bs != 0:
            padding_length = (bs - len(chunk) % bs) or bs
            chunk += str.encode(
                padding_length * chr(padding_length)
                )
            finished = True
        out_file.write(cipher.encrypt(chunk))

def decrypt(in_file, out_file, password, key_length=32):
    '''
    Takes an input file and outputfile and a secret user password.
    The first two blocks of AES.block_size contain the salt and iv.
    Reads a file encrypted with according to the AES standard
    with a "Counter" block cipher, in chunks of 1024 * 16 bits,
    writes the decoded file to disc.
    '''
    bs = AES.block_size
    salt_and_iv = in_file.read(2 * bs)
    salt = salt_and_iv[: bs]
    iv = salt_and_iv[bs: 2 * bs]
    key = derive_key(password, salt, key_length)
    ctr = create_counter(iv, bs)
    cipher = AES.new(key, AES.MODE_CTR, counter=ctr)
    next_chunk = ''
    finished = False
    while not finished:
        chunk, next_chunk = next_chunk, cipher.decrypt(
            in_file.read(1024 * bs))
        if len(next_chunk) == 0:
            padding_length = chunk[-1]
            chunk = chunk[:-padding_length]
            finished = True
        out_file.write(bytes(x for x in chunk))
