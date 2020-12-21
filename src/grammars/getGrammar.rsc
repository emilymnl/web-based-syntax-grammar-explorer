module grammars::getGrammar

import ParseTree;
import vis::Figure;
import vis::ParseTree;
import vis::Render;

import IO;
import Type;
import Map;
import String;

lexical Whitespace = [\ \t\n];
layout MyLayout = Whitespace*;
lexical NUM = [0-9]+;
syntax Expr = NUM | "E" > left "(" Expr ")" > left Expr "+" Expr;

public map[int, map[str, list[str]]] getGrammarMap(Tree t) {
	dic = ();
	subdic = ();
	i = 0;
	lis = [];

   	visit(t) {
   		case a : appl(prod(s,l,_),_): {
            if (("<a>") != ("") || ("<s>") != ("")) {
            	str sortsort = "<s>";
       			str aTrimmed = replaceAll("<a>", " ", "");
            	
            	// check for parantheses
        		li = l;
        		if (size(li) == 5) {
        			middle = li[2];
        			if (middle == sort("Expr")) {
        				//println(li);
        				firstpar = li[0][0];
        				lastpar = li[-1][0];
        				middle = li[2][0];
        				//middle = aTrimmed;
        				
        				println("par: <firstpar> <middle> <lastpar>");
        				lis = [] + "<firstpar>";
	            		lis += "<middle>";
	            		lis += "<lastpar>";
		            	subdic = ("par": lis);
		            	dic = dic + (i : subdic);
		            	i = i + 1;
        			}
        		}
	            // check for sort 
            	if (sortsort[..4] == "sort"){
            		println("sort: <printSymbol(s, false)> <aTrimmed>");
            		lis = [] + "<printSymbol(s, false)>";
            		lis += "<aTrimmed>";
	            	subdic = ("sort": lis);
	            	dic = dic + (i : subdic);
	            	i = i + 1;
            	}
            	// check for lit
            	if (sortsort[..3] == "lit"){
        			println("lit: <aTrimmed>");
            		lis = [] + "<printSymbol(s, false)>";
            		lis += "<aTrimmed>";
	            	subdic = ("lit": lis);
	            	dic = dic + (i : subdic);
	            	i = i + 1;
            	} 
            	// check for lex
            	if (sortsort[..3] == "lex"){
            		if (aTrimmed != "") {
            			println("lex: <printSymbol(s, false)> <aTrimmed>");
            			lis = [] + "<printSymbol(s, false)>";
            			lis += "<aTrimmed>";
	            		subdic = ("lex": lis);
		            	dic = dic + (i : subdic);
		            	i = i + 1;
	            	}
            	} 
            	
            }   
        }
    }
    return dic;
}

void main() {
}


