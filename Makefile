minscript: parser
	echo "(function (exports) {" > build/minscript.js

	cat src/parser.js >> build/minscript.js
	coffee -cpb src/emitter.coffee >> build/minscript.js
	coffee -cpb src/wrapper.coffee >> build/minscript.js
	coffee -cpb src/minscript.coffee >> build/minscript.js

	echo "})(typeof exports === 'undefined' ? this['MinScript']={} : exports);" >> build/minscript.js

min: minscript
	cat build/minscript.js > build/minscript.min.temp
	cat src/domeval.js >> build/minscript.min.temp
	uglifyjs build/minscript.min.temp > build/minscript.min.js
	rm build/minscript.min.temp

parser:
	jison src/parser.jison -o src/parser.js
