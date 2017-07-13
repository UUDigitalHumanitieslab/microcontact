from . import encryption
import filecmp
from os import urandom, path, makedirs
from Crypto.Random import random

TEST_DIRECTORY = '.tmp/testcases'


def test_encryption():
    # loads test audio file, encrypts and decrypts it, and compares original and encrypted file
    test_password = urandom(12)
    if not path.exists(TEST_DIRECTORY):
        makedirs(TEST_DIRECTORY)
    with open('microcontact/testcases/mingus.mp3', 'rb') as in_file,\
            open(path.join(TEST_DIRECTORY, 'mingus.enc'), 'wb') as enc_file:
        encryption.encrypt(in_file, enc_file, test_password)
    with open(path.join(TEST_DIRECTORY, 'mingus.enc'), 'rb') as enc_file,\
            open(path.join(TEST_DIRECTORY, 'mingusnew.mp3'), 'wb') as dec_file:
        encryption.decrypt(enc_file, dec_file, test_password)
    assert filecmp.cmp('microcontact/testcases/mingus.mp3',
                       path.join(TEST_DIRECTORY, 'mingusnew.mp3'), False)
