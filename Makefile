minscript: parser emitter wrapper main
	echo "(function (exports) {" > build/parser.js
	cat src/parser.js >> build/parser.js
	echo "})(typeof exports === undefined ? this['parser']={} : exports);" >> build/parser.js

	cat build/parser.js > build/minscript.js
	cat build/emitter.js >> build/minscript.js
	cat build/wrapper.js >> build/minscript.js
	cat build/main.js >> build/minscript.js
	rm build/parser.js
	rm build/emitter.js
	rm build/wrapper.js
	rm build/main.js

min: minscript
	uglifyjs build/minscript.js > build/minscript.min.js

main:
	echo "(function (exports) {" > build/main.js
	coffee -cpb src/minscript.coffee >> build/main.js
	echo "})(typeof exports === undefined ? this['minscript']={} : exports);" >> build/main.js

parser:
	jison src/parser.jison -o src/parser.js

emitter:
	echo "(function (exports) {" > build/emitter.js
	coffee -cpb src/emitter.coffee >> build/emitter.js
	echo "})(typeof exports === undefined ? this['emitter']={} : exports);" >> build/emitter.js

wrapper:
	echo "(function (exports) {" > build/wrapper.js
	coffee -cpb src/wrapper.coffee >> build/wrapper.js
	echo "})(typeof exports === undefined ? this['wrapper']={} : exports);" >> build/wrapper.js