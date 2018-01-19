This is a project that aims to create a music recommender with Prolog and Wikidata as a knowledge base.

The file recommender.pl contains the main logic of the aplication, and songs.pl is a generated file that contains the assertion of
the songs and the labels of them. They should be run at the same time.

To generate the songs.pl file Python was used to parse the JSON results of the SPARQL query performed to Wikidata (https://query.wikidata.org/).
This parsing is done in the file WikidataToProlog.py.
