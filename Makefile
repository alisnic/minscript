default: cli browser

browser:
	whoami

cli: parser

parser:
	jison src/parser.jison -o src/parser.js