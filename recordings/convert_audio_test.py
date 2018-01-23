from . import convert_audio
import os
import os.path
import shutil

INFILE = 'speech.amr'
OUTFILE = 'speech.mp3'


def test_convert_to_mp3(testcase_dir, tmpdir):
    source = os.path.join(testcase_dir, INFILE)
    infile = os.path.join(str(tmpdir), INFILE)
    shutil.copyfile(source, infile)
    convert_audio.convert_to_mp3(infile)
    assert(OUTFILE in os.listdir(str(tmpdir)))
