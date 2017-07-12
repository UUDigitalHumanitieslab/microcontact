import subprocess
import os

def convert_to_mp3(infile):
	"""
	given an input file in any format supported by ffmpeg,
	export to mp3
	"""
	# possible to link to Recording object from models.py
	#infile = recording.recording_link
	outfile = os.path.splitext(infile)[0] + '.mp3'
	# output as a one-channel, 128kbit mp3 (variable bit rate)
	# -ar flag omitted, this automatically uses input sampling rate
	query_string = 'ffmpeg -i ' + infile + \
	 ' -acodec mp3 -ac 1 -ab 128k -hide_banner '\
	  + outfile
	subprocess.run(query_string, shell=True, check=True)