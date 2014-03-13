%lex
%%

\s+        /* whitespace */
";"[^\n]+  /* comments */

"("  { return '('; }
")"  { return ')'; }


\"(\\.|[^"])*\"  yytext = yytext.substr(1,yyleng-2); return 'STRING';
\'(\\.|[^'])*\'  yytext = yytext.substr(1,yyleng-2); return 'sqSTRING';

"-"?[0-9]+"."[0-9]+ { return 'FLOAT'; }
"-"?[0-9]+          { return 'INT'; }
":"\w+              { return 'KEYWORD'; }
"%"\d+              { return 'ARG' }
"&:"\w+             { return 'ATTRFN' }
"&&:"\w+            { return 'FUNFN' }
"#"                 { return 'QUICKFN' }

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
  | anonfn
    { $$ = $anonfn; }
  ;

anonfn
  : 'QUICKFN' '(' ')'
    { $$ = [] }
  | 'QUICKFN' '(' items ')'
    { $$ = ['fn', []].concat([$items]) }
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
  | sqSTRING
    { $$ = {value: ("'" + $sqSTRING + "'")}; }
  | boolean
    { $$ = {value: $boolean}; }
  | SYMBOL
    { $$ = yytext.replace(/-/g, '_'); }
  | ARG
    { $$ = {value: ('arguments[' + yytext.replace(/^\%/,'') + ']')} }
  | KEYWORD
    { $$ = {value: ('"' + yytext.replace(/^\:/,'') + '"')} }
  | ATTRFN
    { $$ = ['fn', [], {value: 'arguments[0].' + yytext.replace(/[\:\&]/g,'')}] }
  | FUNFN
    { $$ = ['fn', [], ['arguments[0].' + yytext.replace(/[\:\&]/g,'')]] }
  | NIL
    { $$ = {value: null, null: true}; }
  ;

