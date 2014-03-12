default: cli browser

browser:
	whoami

cli: parser

parser:
	jison lib/parser.jison -o lib/parser.js