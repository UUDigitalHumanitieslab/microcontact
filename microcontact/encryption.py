from os import urandom
from hashlib import md5
import sys
# need to install package pycrypto
from Crypto.Cipher import AES

def derive_key_and_iv(password, salt, key_length, iv_length):
    d = d_i = b''
    while len(d) < key_length + iv_length:
        if type(password) is str:
            password = password.encode(encoding='UTF-8')
        d_i = md5(d_i + password + salt).digest()
        d += d_i
    return d[:key_length], d[key_length:key_length+iv_length]

def encrypt(in_file, out_file, password, salt_header='', key_length=32):
    print(sys.version_info)
    bs = AES.block_size
    salt = urandom(bs - len(salt_header))
    key, iv = derive_key_and_iv(password, salt, key_length, bs)
    cipher = AES.new(key, AES.MODE_CBC, iv)
    out_file.write(str.encode(salt_header) + salt)
    finished = False
    while not finished:
        chunk = in_file.read(1024 * bs) 
        if len(chunk) == 0 or len(chunk) % bs != 0:
            padding_length = (bs - len(chunk) % bs) or bs
            # changed right side to str.encode(...)
            chunk += str.encode(
                padding_length * chr(padding_length))
            finished = True
        out_file.write(cipher.encrypt(chunk))

def decrypt(in_file, out_file, password, salt_header='', key_length=32):
    bs = AES.block_size
    salt = in_file.read(bs)[len(salt_header):]
    key, iv = derive_key_and_iv(password, salt, key_length, bs)
    cipher = AES.new(key, AES.MODE_CBC, iv)
    next_chunk = ''
    finished = False
    counter = 0
    while not finished:
        chunk, next_chunk = next_chunk, cipher.decrypt(
            in_file.read(1024 * bs))
        if len(next_chunk) == 0:
            padding_length = chunk[-1]
            chunk = chunk[:-padding_length]
            finished = True
        out_file.write(bytes(x for x in chunk))