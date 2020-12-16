module webapp::testMain

// some tests with main + syntax 

import webapp::RunApp;

public str nesteMain(str text, str gram) {

str hele = "module webapp::RunTest
import demo::lang::Exp::Concrete::NoLayout::Syntax;
import ParseTree;
	
import IO;
import List;
import grammars::getGrammar;
import webapp::htmlContent;

import webapp::jsContent;
import webapp::cssContent;
import grammars::GrammarContent;
import Map;

import util::Webserver;
import Content;

import util::Math;
import String;
import grammars::UserGrammar;
//import grammars::te;

import Type;
import Set;
"
+
gram
+
"public void main2() {
	println(\"start server 2\");
	startServer();
	
	//startServer(s);
	//shutdownServer();
}

void startServer() {
	str s = \"1+2*3+4\"; // initial text
	
	map[int, map[str, str]] mapOfNodes = getGrammar2(parse(#Expr, s)); 
	
	set[str] exprr = mapOfNodes[(size(mapOfNodes)-1)]\<1\>;	// get the input final expression of the tree
	str expression = min(exprr);								// min() removes { and } and only returns the string
	//writeFile(expression, mapOfNodes);					// legge til html, med css og js (treet).
	
	str tempGrammar = \"\";
	// this serves the initial form
	Response myServer(get(\"/\")) 
	  = response(htmlFilled(expression, tempGrammar, mapOfNodes));
	             
	println(\"------- STARTED SERVER SUCCESSFULLY2 -------\");
	
	Response myServer(p:get(\"/submit\")) {
		str tex = \"\<p.parameters[\"text\"]\>\";
		str nTex = replaceAll(tex, \"\\n\", \"\");
		str tTex = replaceAll(nTex, \"\\t\", \"\");
		str rTex = replaceAll(tTex, \"\\r\", \"\");
		println(\"teksten2: \" +rTex);
		
		println(\"----- before grammar2\");
		println(grammar);
		str grammar = \"\<p.parameters[\"grammar\"]\>\";
		if (grammar == \"\") {
			try {
				println(\"----- after grammar2\");
				println(grammar);
				//main();
				//mapOfNodes = userGrammar(rTex);
				
				//shutdownServer();
				//main();
				//shutdownServer();
				//writeFile(|project://web-based-syntax-grammar-explorer/src/webapp/RunTest.rsc|, nesteMain(rTex, grammar));
				
				//main2();
				
			} catch ParseError(loc l): {
			  	println(\"Grammar error at line \<l.begin.line\>, column \<l.begin.column\>\");
			
			}
		} else {
			try {
	  			mapOfNodes = getGrammar2(parse(#Expr, rTex));
	  			println(\"00000000000 text2\");
			}
			catch ParseError(loc l): {
	  			println(\"Parse error at line \<l.begin.line\>, column \<l.begin.column\>\");
			}
		}
		
	   	return response(htmlFilled(tex, grammar, mapOfNodes));
	   	//return response(t);
	   	
	}
	
	// in case of failing to handle a request, we dump the request back for debugging purposes:
	default Response myServer(Request q) = response(\"\<q\>\");
	
	//start
	serve(|http://localhost:10001|, myServer);
	//shutdownServer();
}

map[int, map[str, str]] getGrammar2(Tree exp) {
	//mapOfNodes = getTreeNodes(s); // get standard grammar from library
	mapOfNodes = getTreeNodes(exp);
	return mapOfNodes;
}

void shutdownServer() {
	//shutdown(|http://localhost:8080|);
	shutdown(|http://localhost:10001|);
	
	println(\"-------- SHUTDOWN SERVER SUCCESSFULLY2 -------\");
}

";
return hele;

}
	
