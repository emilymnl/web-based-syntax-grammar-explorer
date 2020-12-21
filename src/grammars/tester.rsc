module grammars::tester

// NOTE: Not used

import demo::lang::Exp::Concrete::NoLayout::Syntax;
import demo::lang::Exp::Combined::Automatic::Parse;
import ParseTree;
import vis::Figure;
import vis::ParseTree;
import vis::Render;

import IO;

import util::Webserver;
import Content;

/*
lexical Whitespace = [\ \t\n];
layout MyLayout = Whitespace*;
lexical NUM = [0-9]+;
lexical Id = [a-z]+;

syntax Expr
    = NUM 
    | Id Expr
    > left Expr "+" Expr
    > left Expr "*" Expr
    | "("  Expr  ")"
    ;

lexical NUM = [0-9]+;
lexical Id = [a-z]+;

start syntax Expr = NUM | Id Expr > left Expr "+" Expr > left Expr "*" Expr;*/
/*
lexical NUM = [0-9]+;
syntax Expr = 
    NUM 
    | "A" 
    > left Expr "b" Expr
    > left Expr "a" Expr;*/
    
lexical Whitespace = [\ \t\n];
layout MyLayout = Whitespace*;
lexical NUM = [0-9]+;
syntax Expr = NUM | "E" > left "(" Expr ")" > left Expr "+" Expr;

void main() {
	
	//start
	//serve(|http://localhost:10001|, myServer);
	//shutdown(|http://localhost:10001|);
	//println(parse(#Exprr, "2+3*4+5+6*7"));
	render(visParsetree(parse(#Expr,"2a3b4a5a51a52a6b7")));
	//render(visParsetree(parseExp("2+3*4+5+51+52+6*7")));
	//iprintln(#Exprr.definitions);
}


