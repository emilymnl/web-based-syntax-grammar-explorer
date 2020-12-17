module grammars::UserGrammar

lexical Whitespace = [\ \n];
layout MyLayout = Whitespace*;
lexical NUM = [0-9]+;
lexical Id = [a-z]+;

syntax Exprr
    = NUM 
    | Id Exprr
    > left Exprr "+" Exprr
    > left Exprr "*" Exprr
    | "("  Exprr  ")"
    ;

