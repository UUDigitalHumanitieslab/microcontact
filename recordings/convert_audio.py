import subprocess
import os
import sys


if sys.version_info < (3, 5):
    # Backport for older versions of python that lack subprocess.run
    # Thanks to https://stackoverflow.com/a/40590445
    def run(*popenargs, input=None, check=False, **kwargs):
        if input is not None:
            if 'stdin' in kwargs:
                raise ValueError('stdin and input arguments may not both be used.')
            kwargs['stdin'] = subprocess.PIPE

        process = subprocess.Popen(*popenargs, **kwargs)
        try:
            stdout, stderr = process.communicate(input)
        except:
            process.kill()
            process.wait()
            raise
        retcode = process.poll()
        if check and retcode:
            raise subprocess.CalledProcessError(
                retcode, process.args, output=stdout, stderr=stderr)
        return retcode, stdout, stderr
else:
    run = subprocess.run


def convert_to_mp3(infile):
    """
    Given an input file in any format supported by ffmpeg, export to mp3.
    
    `infile` should be a file path. Return value is the same path, but
    with the extension replaced by '.mp3'.
    """
    # possible to link to Recording object from models.py
    #infile = recording.recording_link
    outfile = os.path.splitext(infile)[0] + '.mp3'
    # output as a one-channel, 128kbit mp3 (variable bit rate)
    # -ar flag omitted, this automatically uses input sampling rate
    # does not show log output (as this goes to stderr)
    # always overwrites files (-y)
    query_string = 'ffmpeg -i ' + infile + \
     ' -acodec mp3 -ac 1 -ab 128k -hide_banner -loglevel panic -y '\
      + outfile
    run(query_string, shell=True, check=True)
    return outfile
