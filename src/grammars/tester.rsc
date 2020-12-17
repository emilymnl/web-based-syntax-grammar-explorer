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

/*
lexical Whitespace = [\ \n];
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
*/
lexical NUM = [0-9]+;
lexical Id = [a-z]+;

start syntax Expr = NUM | Id Expr > left Expr "+" Expr > left Expr "*" Expr;

void main() {
	
	str gs = trim(readFile(|project://web-based-syntax-grammar-explorer/src/grammars/UserGrammar.rsc|));
                                    
	str name = split("\n",split("module ",gs)[1])[0];
	
	println("Extraction completed.");
	println("The name: " + name);
	
	Grammar g = modules2grammar(name,{parse(#Expr, name)});
	//println("The g: " + g);
	
	pp(normalise(grammar2grammar(g)));
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
	render(visParsetree(parse(#Expr,"2+3*4+5+51+52+6*7")));
	//render(visParsetree(parseExp("2+3*4+5+51+52+6*7")));
	//iprintln(#Exprr.definitions);
}


