from . import convert_audio
import os
import os.path

BASE = os.path.join('recordings', 'testcases')
INFILE = 'speech.amr'
OUTFILE = 'speech.mp3'


def test_conversion():
    infile = os.path.join(BASE, INFILE)
    convert_audio.convert_to_mp3(infile)
    assert(OUTFILE in os.listdir(BASE))
