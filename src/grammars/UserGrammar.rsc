module grammars::UserGrammar

import ParseTree;
//import demo::lang::Exp::Combined::Automatic::Parse;
import grammars::getGrammar;
import Map;

lexical Whitespace = [\ \n];
layout MyLayout = Whitespace*;
lexical NUMw = [0-9]+;
lexical Id = [a-z]+;

syntax Expr
    = NUMw 
    | Id Expr
    > left Expr "+" Expr
    > left Expr "*" Expr
    > left Expr "/" Expr
    | "("  Expr  ")"
;


public map[int, map[str, str]] userGram(str text) {
	mapOfNodes = getTreeNodes(parse(#Expr, text));
	return mapOfNodes;
}