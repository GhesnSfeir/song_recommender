import json
import sys

reload(sys)
sys.setdefaultencoding('utf-8')
doc = "query.json"
prog = "songs.pl"

names = set()
genres = set()
languages = set()
performers = set()

def process(song, dataOut):
	g = song['genreLabel']
	if g not in genres:
		genres.add(g)
		dataOut.write("label(\"" + g + "\",0).\n")
		
	l = song['language_of_work_or_nameLabel']
	if l not in languages:
		languages.add(l)
		dataOut.write("label(\"" + l + "\",0).\n") 
		
	p = song['performerLabel']
	if p not in performers:
		performers.add(p)
		dataOut.write("label(\"" + p + "\",0).\n")
		
	n = song['songLabel']
	if n not in names:
		names.add(n)
		dataOut.write("song(\"" + n + "\", \"" + g + "\", \"" + l + "\", \"" + p + "\").\n")
	


def main():
	dataOut = open(prog,"w")
	dataIn = open(doc, "r")
	f = json.load(dataIn)
	dataIn.close()
	
	dataOut.write(":- discontiguous label/2.\n")
	dataOut.write(":- discontiguous song/4.\n")
	
	for song in f:
		process(song, dataOut)
		
	dataOut.close()
