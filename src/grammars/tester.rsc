module grammars::tester

import demo::lang::Exp::Concrete::NoLayout::Syntax;
import demo::lang::Exp::Combined::Automatic::Parse;
import ParseTree;
import vis::Figure;
import vis::ParseTree;
import vis::Render;

import IO;

import util::Webserver;
import Content;


lexical Whitespace = [\ \n];
layout MyLayout = Whitespace*;
lexical NUM = [0-9]+;
lexical Id = [a-z]+;

syntax Exprr
    = NUM 
    | Id Exprr
    > left Exprr "+" Exprr
    > left Exprr "*" Exprr
    > left Exprr "/" Exprr
    | "("  Exprr  ")"
    ;

void main() {
	//println((parse(#Exp, "1+2*3+4")));
	
	// this serves the initial form
	/*
	Response myServer(get("/")) 
	  = response("\<h2\>What is your name heh?\</h2\>
	             '\<form action=\"/submit\" method=\"GET\"\>
	             '   \<input type=\"text\" name=\"name\" value=\"\"\> \</input\>
	             '\</form\>
	             ");   
	 */
	
	// this responds to the form submission, now using a function body with a return (just for fun):
	/*
	Response myServer(p:get("/submit")) {
	   return response("\<h2\>What is your name heh?\</h2\>
	             	   	'\<form action=\"/submit\" method=\"GET\"\>
	            		'   \<input type=\"text\" name=\"name\" \> \</input\>
	             		'\</form\>
	            		" + " Hellooo <p.parameters["name"]>!");
	}*/
	
	// in case of failing to handle a request, we dump the request back for debugging purposes:
	//default Response myServer(Request q) = response("<q>");
	
	//start
	//serve(|http://localhost:10001|, myServer);
	//shutdown(|http://localhost:10001|);
	//println(parse(#Exprr, "2+3*4+5+6*7"));
	render(visParsetree(parseExp("2+3*4+5+51+52+6*7")));
	//iprintln(#Exprr.definitions);
}


