module webapp::RunApp

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
//import grammars::tester; ///
//import webapp::testMain;
//import webapp::RunTest;
//import lang::rascal::grammar::definition::Modules;

import Type;
import Set;
import Module;

void main() {
	startServer();
}

void startServer() {
	str s = "1+2*3+4"; // initial text
	str tempGrammar = ""; // initial empty grammar
	
	map[int, map[str, str]] mapOfNodes = getGrammar(s); 
	
	// get the input final expression of the tree
	set[str] exprr = mapOfNodes[(size(mapOfNodes)-1)]<1>;
	// min() removes { and } and only returns the string	
	str expression = min(exprr);
	// adds the html, with css and js (the tree).							
	//writeFile(expression, mapOfNodes);					
	
	
	// this serves the initial form
	Response myServer(get("/")) 
	  = response(htmlFilled(expression, tempGrammar, mapOfNodes));
	             
	println("------- STARTED SERVER -------");
	
	// this responds to the form submission
	Response myServer(p:get("/submit")) {
		str tex = "<p.parameters["text"]>";
		str nTex = replaceAll(tex, "\n", "");
		str tTex = replaceAll(nTex, "\t", "");
		str rTex = replaceAll(tTex, "\r", "");
		println("teksten: " +rTex);
		
		str grammar = "<p.parameters["grammar"]>";
		if (grammar != "") {
			try {
				println("----- grammar");
				
				//currently dont do anything - im fixing this
				
				//shutdownServer();
				//writeFile(|project://web-based-syntax-grammar-explorer/src/grammars/UserGrammar.rsc|, grammarFilled(rTex,grammar));
				
				//println(grammar);
				//mapOfNodes = userGram(rTex);

				
			} catch ParseError(loc l): {
			  	println("Grammar error at line <l.begin.line>, column <l.begin.column>");
			
			}
		} else {
			try {
	  			mapOfNodes = getGrammar(rTex);
	  			println("trying the new text input");
			}
			catch ParseError(loc l): {
	  			println("Parse error at line <l.begin.line>, column <l.begin.column>");
	  			
	  			//return response(htmlFilled(tex, grammar, mapOfNodes));
			}
		}
		
	   	return response(htmlFilled(tex, grammar, mapOfNodes));
	   	
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
	//shutdown(|http://localhost:8080|);
	shutdown(|http://localhost:10001|);
	
	println("-------- SHUTDOWN SERVER -------");
}




