module grammars::getGrammar

import ParseTree;
import vis::Figure;
import vis::ParseTree;
import vis::Render;

import IO;
import Type;
import Map;

public map[int, map[str, str]] getGrammarMap(Tree t) {
	dic = ();
	subdic = ();
	i = 0;

   	visit(t) {
        case a : appl(prod(s,_,_),_): {
            if (("<a>") != ("")) {
            	subdic = ("<printSymbol(s, false)>" : "<a>");
            	dic = dic + (i : subdic);
            	i = i + 1;
            }   
        }		
    }
    return dic;
}

void main() {
}


