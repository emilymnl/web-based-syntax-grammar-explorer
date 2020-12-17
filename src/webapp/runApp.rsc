module webapp::runApp

import demo::lang::Exp::Concrete::NoLayout::Syntax;
//import demo::lang::Exp::Combined::Automatic::Parse;
import ParseTree;

import IO;
import List;
import grammars::getGrammar;
import webapp::htmlContent;

import grammars::GrammarContent;
import Map;

import util::Webserver;
import Content;

import util::Math;
import String;
import grammars::UserGrammar;

import Type;
import Set;
import Module;

import grammars::newGrammar;
import Symbol;

void main() {
	startServer();
}

void startServer() {
	// initial text
	str text = "1+2*3+4"; 
	// initial empty grammar
	str grammar = ""; 
	
	map[int, map[str, str]] mapOfNodes = getGrammar(text); 
	
	// get the input final expression of the tree
	set[str] exprr = mapOfNodes[(size(mapOfNodes)-1)]<1>;
	// min() removes { and } and only returns the string	
	str expression = min(exprr);
	// adds the html, with css and js (the tree).							
	//writeFile(expression, mapOfNodes);					
	
	
	// this serves the initial form
	Response myServer(get("/")) 
	  = response(htmlFilled(expression, grammar, mapOfNodes));
	             
	println("------- STARTED SERVER -------");
	
	// this responds to the form submission
	Response myServer(p:get("/submit")) {
		text = "<p.parameters["text"]>";
		str nTex = replaceAll(text, "\n", "");
		str tTex = replaceAll(nTex, "\t", "");
		str rTex = replaceAll(tTex, "\r", "");
		println("teksten: " +rTex);
		
		grammar = "<p.parameters["grammar"]>";
		if (grammar != "") {
			try {
				println("grammar has been entered by user");
				// transforms the grammar input into a reified type that includes the grammar in abstract form
				type[Tree] typeTreeGrammar = modifyGrammar(\sort("Expr"), grammar);
   				// making map of the grammar for the parse tree, when parsing the text and the grammar from user
   				mapOfNodes = getTreeNodes(parse(typeTreeGrammar, rTex));
				
			} catch ParseError(loc l): {
			  	println("Grammar error at line <l.begin.line>, column <l.begin.column>");
			}
		} else {
			try {
	  			mapOfNodes = getGrammar(rTex);
	  			println("trying the new text input from user");
			}
			catch ParseError(loc l): {
	  			println("Parse error at line <l.begin.line>, column <l.begin.column>");
			}
		}
		
	   	return response(htmlFilled(text, grammar, mapOfNodes));
	   	
	}
	
	// in case of failing to handle a request, we dump the request back for debugging purposes:
	default Response myServer(Request q) = response("<q>");
	
	//start server
	serve(|http://localhost:10001|, myServer);
	//shutdownServer();
}

map[int, map[str, str]] getGrammar(str s) {
	//mapOfNodes = getTreeNodes(s); // get standard grammar from library
	mapOfNodes = getTreeNodes(parse(#Exp, s));
	return mapOfNodes;
}
/*
// dont need this anymore if i host it on a server - but nice temporarily
void writeFile(str expression, map[int, map[str, str]] gram){
	// html
	writeFile(|file:///Users/emilyminguyen/uib/7.semester/INF225/termproject/web-based-syntax-grammar-explorer/src/webapp/demoRunApp.html|, 
	htmlFilled(expression, gram)
	);
	
	// js
	writeFile(|file:///Users/emilyminguyen/uib/7.semester/INF225/termproject/web-based-syntax-grammar-explorer/src/webapp/demoRunApp.js|, 
	jsFilled(gram)
	);
	
	//css
	writeFile(|file:///Users/emilyminguyen/uib/7.semester/INF225/termproject/web-based-syntax-grammar-explorer/src/webapp/demoRunApp.css|, 
	cssFilled()
	);
}*/

void shutdownServer() {
	shutdown(|http://localhost:10001|);
	
	println("-------- SHUTDOWN SERVER -------");
}




