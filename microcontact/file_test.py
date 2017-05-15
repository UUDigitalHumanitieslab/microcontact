from . import encryption
import filecmp
from os import urandom, getcwd

def test_encryption():
	# loads test audio file, encrypts and decrypts it, and compares original and encrypted file
	test_key = urandom(12)
	with open('microcontact/testcases/mingus.mp3', 'rb') as in_file,\
	 open('microcontact/testcases/mingus.enc', 'wb') as enc_file:
		encryption.encrypt(in_file, enc_file, test_key)
	with open('microcontact/testcases/mingus.enc', 'rb') as enc_file,\
	 open('microcontact/testcases/mingusnew.mp3', 'wb') as dec_file:
		encryption.decrypt(enc_file, dec_file, test_key)
	assert filecmp.cmp('microcontact/testcases/mingus.mp3', 
	 'microcontact/testcases/mingusnew.mp3', False)



