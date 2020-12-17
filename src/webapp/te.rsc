module webapp::te

import lang::rascal::grammar::definition::Modules;
import lang::rascal::\syntax::Rascal;
import Grammar;
import IO;

type[Tree] commitGrammar(Symbol s, str newText) {
   Module m = parse(#start[Module], "module Dummy
                                    '
                                    '<newText>").top;
                                    
   Grammar gm = modules2grammar("Dummy", {m});
   println(gm.rules<0>);
   /*
   if (s notin gm.rules<0>) {
     if (x:\start(_) <- gm.rules) {
       s = x;
     }
     else if (x <- gm.rules) {
       s = x;
     }
   }*/
   
   if (type[Tree] gr := type(s, gm.rules)) {
     return gr;
   }
   
   throw "could not generate a proper grammar: <gm>";
}

void main() {

	//str newText = "lexical NUM = [0-9]+;\nlexical Id = [a-z];\nsyntax Expr = NUM | Id Expr \> left Expr \"+\" Expr \> left Expr \"*\" Expr";
	
	//Symbol s = expr;
	
	//str te = "1+2";
	
	//hei = commitGrammar(newText);
	
	//listen = getTreeNodes(parse(#Expr, te));
}