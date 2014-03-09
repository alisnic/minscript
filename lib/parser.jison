%lex
%%

\s+        /* whitespace */
";"[^\n]+  /* comments */

"("  { return '('; }
")"  { return ')'; }


\"(\\.|[^"])*\"  yytext = yytext.substr(1,yyleng-2); return 'STRING';

"-"?[0-9]+"."[0-9]+ { return 'FLOAT'; }
"-"?[0-9]+          { return 'INT'; }
":"\w+    { return 'KEYWORD'; }

nil  { return 'NIL'; }
true  { return 'TRUE'; }
false  { return 'FALSE'; }

[-+/*_<>=a-zA-Z.]+  { return 'SYMBOL'; }

<<EOF>>    { return 'EOF'; }

/lex

%%

file
  : sexps EOF
    { return $sexps; }
  ;

sexps
  : sexp
    { $$ = [$sexp]; }
  | sexp sexps
    { $$ = [$sexp].concat($sexps); }
  ;

sexp
  : atom
    { $$ = $atom; }
  | list
    { $$ = $list; }
  ;

pairs
  : pair
    { $$ = [$pair]; }
  | pair pairs
    { $$ = [$pair].concat($pairs); }
  ;

pair
  : sexp sexp
    { $$ = [$sexp1, $sexp2]; }
  ;

list
  : '(' ')'
    { $$ = []; }
  | '(' items ')'
    { $$ = $items; }
  ;


items
  : sexp
    { $$ = [$sexp]; }
  | sexp items
    { $$ = [$sexp].concat($items); }
  ;

boolean
  : TRUE
    { $$ = true; }
  | FALSE
    { $$ = false; }
  ;

atom
  : INT
    { $$ = {value: parseInt($INT, 10)}; }
  | FLOAT
    { $$ = {value: parseFloat($FLOAT)}; }
  | STRING
    { $$ = {value: ('"' + $STRING + '"')}; }
  | boolean
    { $$ = {value: $boolean}; }
  | SYMBOL
    { $$ = $SYMBOL; }
  | KEYWORD
    { $$ = {value: ('"' + yytext.replace(/^\:/,'') + '"')} }
  | NIL
    { $$ = {value: null, null: true}; }
  ;

