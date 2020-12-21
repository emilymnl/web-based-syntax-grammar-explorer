module webapp::runApp

import demo::lang::Exp::Concrete::NoLayout::Syntax;
import ParseTree;
import IO;
import List;
import Map;
import String;
import Type;
import Set;
import Module;
import Symbol;

import grammars::getGrammar;
import grammars::newGrammar;
import webapp::htmlContent;

// server
import util::Webserver;
import Content;


void main() {
	startServer();
}

void startServer() {
	// initial text
	str text = "1+2*3+4"; 
	// initial empty grammar
	str grammar = ""; 
	
	map[int, map[str, list[str]]] mapOfGrammar = getGrammarMap(parse(#Exp, text));
	
	// get the last expression of the tree
	set[list[str]] ex = mapOfGrammar[(size(mapOfGrammar)-1)]<1>;
	// min() removes { and } and only returns the string
	str expression = min(ex)[1];			
	
	// this serves the initial form
	Response myServer(get("/")) 
	  = response(htmlFilled(expression, grammar, mapOfGrammar));
	             
	println("------- STARTED SERVER -------");
	
	// this responds to the form submission
	Response myServer(p:get("/submit")) {
		text = "<p.parameters["text"]>";
		str nTex = replaceAll(text, "\n", "");
		str tTex = replaceAll(nTex, "\t", "");
		str rTex = replaceAll(tTex, "\r", "");
		println("the text: " +rTex);
		
		grammar = "<p.parameters["grammar"]>";
		if (grammar != "") {
			try {
				println("grammar has been entered by user");
				// transforms the grammar input into a reified type that includes the grammar in abstract form
				type[Tree] typeTreeGrammar = modifyGrammar(\sort("Expr"), grammar);
   				// making map of the grammar for the parse tree, when parsing the text and the grammar from user
   				mapOfGrammar = getGrammarMap(parse(typeTreeGrammar, rTex));
				
			} catch ParseError(loc l): {
			  	println("Grammar error at line <l.begin.line>, column <l.begin.column>");
			}
		} else {
			try {
	  			mapOfGrammar = getGrammarMap(parse(#Exp, rTex));
	  			println("trying the new text input from user");
			}
			catch ParseError(loc l): {
	  			println("Parse error at line <l.begin.line>, column <l.begin.column>");
			}
		}
	   	return response(htmlFilled(text, grammar, mapOfGrammar));
	}
	
	// in case of failing to handle a request, we dump the request back for debugging purposes:
	default Response myServer(Request q) = response("<q>");
	
	//start server
	serve(|http://localhost:10001|, myServer);
}

void shutdownServer() {
	shutdown(|http://localhost:10001|);
	
	println("-------- SHUTDOWN SERVER -------");
}




