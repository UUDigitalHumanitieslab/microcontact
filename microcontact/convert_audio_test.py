import convert_audio
import os

def test_conversion():
	infile = "testcases/speech.amr"
	convert_audio.convert_to_mp3(infile)
	assert("speech.mp3" in os.listdir("testcases"))