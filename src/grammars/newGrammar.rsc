module grammars::newGrammar

import lang::rascal::grammar::definition::Modules;
import lang::rascal::\syntax::Rascal;
import Grammar;
import IO;

public type[Tree] modifyGrammar(Symbol s, str newText) {
   Module m = parse(#start[Module], "module Dummy
                                    '
                                    '<newText>").top;
   // from module to a reified type that includes the grammar in abstract form                                
   Grammar gm = modules2grammar("Dummy", {m});
   
   if (type[Tree] gr := type(s, gm.rules)) {
     return gr;
   }
   
   throw "could not generate a proper grammar: <gm>";
}
