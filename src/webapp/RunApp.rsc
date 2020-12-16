module webapp::RunApp

import demo::lang::Exp::Concrete::NoLayout::Syntax;
//import demo::lang::Exp::Combined::Automatic::Parse;
import ParseTree;

import IO;
import List;
import grammars::getGrammar;
import webapp::htmlContent;

//import webapp::jsContent2;
//import webapp::cssContent;
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
    > left Expr "/" Expr
    | "("  Expr  ")"
;
*/
void main() {
	startServer();
	//println(parse(#Expr, "1+2"));
	//iprintln(#Expr.definitions);
	//startServer(s);
	//shutdownServer();
}

void startServer() {
	str s = "1+2*3+4"; // initial text
	
	map[int, map[str, str]] mapOfNodes = getGrammar(s); 
	
	set[str] exprr = mapOfNodes[(size(mapOfNodes)-1)]<1>;	// get the input final expression of the tree
	str expression = min(exprr);								// min() removes { and } and only returns the string
	//writeFile(expression, mapOfNodes);					// legge til html, med css og js (treet).
	
	str tempGrammar = "";
	// this serves the initial form
	Response myServer(get("/")) 
	  = response(htmlFilled(expression, tempGrammar, mapOfNodes));
	             
	println("------- STARTED SERVER -------");
	
	// this responds to the form submission, now using a function body with a return (just for fun):
	Response myServer(p:get("/submit")) {
		str tex = "<p.parameters["text"]>";
		str nTex = replaceAll(tex, "\n", "");
		str tTex = replaceAll(nTex, "\t", "");
		str rTex = replaceAll(tTex, "\r", "");
		println("teksten: " +rTex);
		
		str grammar = "<p.parameters["grammar"]>";
		/*
		str nGrammar = replaceAll(grammar, "\n", "");
		str tGrammar = replaceAll(nGrammar, "\t", "");
		str rGrammar = replaceAll(tGrammar, "\r", "");
		str sGrammar = replaceAll(rGrammar, " ", " ");*/
		if (grammar != "") {
			try {
				println("----- grammar");
				//shutdownServer();
				writeFile(|project://web-based-syntax-grammar-explorer/src/grammars/UserGrammar.rsc|, grammarFilled(rTex,grammar));
				//setModules = {|project://web-based-syntax-grammar-explorer/src/grammars/UserGrammar.rsc|};
				//Grammar something = modules2grammar(userGram, setModules);
				
				/*Module m = parse(#start[Module], "module Dummy
			                                     '
			                                     '<newText>").top;
			    Grammar gm = modules2grammar("Dummy", {m});
			    
			    if (s notin gm.rules<0>) {
				     if (x:\start(_) <- gm.rules) {
				       s = x;
				     }
				     else if (x <- gm.rules) {
				       s = x;
				     }
				   }
				   
				   if (type[Tree] gr := type(s, gm.rules)) {
				     return gr;
				   }
				   
				   throw "could not generate a proper grammar: <gm>";*/
				   
				//str readGrammar = readFile(|project://web-based-syntax-grammar-explorer/src/grammars/UserGrammar.rsc|);
				// get list of grammar
				println(grammar);
				//println(something);
				//main();
				mapOfNodes = userGram(rTex);
				
				//shutdownServer();
				//main();
				//shutdownServer();
				//writeFile(|project://web-based-syntax-grammar-explorer/src/webapp/RunTest.rsc|, nesteMain(rTex, grammar));
				
				//main2();
				//mapOfNodes = getGrammar2(rTex);

				
			} catch ParseError(loc l): {
			  	println("Grammar error at line <l.begin.line>, column <l.begin.column>");
			
			}
		} else {
			try {
	  			mapOfNodes = getGrammar(rTex);
	  			println("00000000000 text2");
			}
			catch ParseError(loc l): {
	  			println("Parse error at line <l.begin.line>, column <l.begin.column>");
	  			
	  			return response(htmlFilled(tex, grammar, mapOfNodes));
			}
		}
		
	   	return response(htmlFilled(tex, grammar, mapOfNodes));
	   	//return response(t);
	   	
	}
	
	// in case of failing to handle a request, we dump the request back for debugging purposes:
	default Response myServer(Request q) = response("<q>");
	
	//start
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
/*
void startServer(str expression, map[int, map[str, str]] gram) {
	
	// this serves the initial form
	Response myServer(get("/")) 
	  = response(htmlFilled(expression, gram));
	             
	println("------- STARTED SERVER -------");
	
	// this responds to the form submission, now using a function body with a return (just for fun):
	Response myServer(p:get("/submit")) {
	   return response(htmlFilled(p.parameters["text"], gram));
	}
	
	// in case of failing to handle a request, we dump the request back for debugging purposes:
	default Response myServer(Request q) = response("<q>");
	
	//start
	serve(|http://localhost:10001|, myServer);

}*/

void shutdownServer() {
	//shutdown(|http://localhost:8080|);
	shutdown(|http://localhost:10001|);
	
	println("-------- SHUTDOWN SERVER -------");
}




