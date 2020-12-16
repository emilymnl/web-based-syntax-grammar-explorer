module grammars::te

import ParseTree;
import demo::lang::Exp::Combined::Automatic::Parse;
import grammars::getGrammar;
import Map;

syntax Expr
    = NUM 
    | Id Expr
    > left Expr "+" Expr
    > left Expr "*" Expr
    > left Expr "/" Expr
    | "("  Expr  ")"
;

public map[int, map[str, str]] oo(str s) {

	mapOfNodes = getTreeNodes(parse(#Expr, s));

	return mapOfNodes;

	}