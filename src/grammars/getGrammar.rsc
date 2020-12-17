module grammars::getGrammar

//import demo::lang::Exp::Concrete::WithLayout::Syntax;
//import demo::lang::Exp::Concrete::NoLayout::Syntax;
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

   	visit(t) {/*
    	case (Expr2)`<Expr2 left>*<Expr2 right>`: {
			//println("MultiExpr: ´<left> * <right>´");
			subdic = ("MultExpr" : "<left>*<right>");
            dic = dic + (i : subdic);
            i = i + 1;
		}
		
		case (Expr2)`<Expr2 left>+<Expr2 right>`: {
			//println("PlusExpr: ´<left> + <right>´");
			subdic = ("PlusExpr" : "<left>+<right>");
            dic = dic + (i : subdic);
            i = i + 1;
		}
		
		case (Expr2)`<Expr2 left>/<Expr2 right>`: {
			//println("PlusExpr: ´<left> / <right>´");
			subdic = ("DivExpr" : "<left>/<right>");
            dic = dic + (i : subdic);
            i = i + 1;
		}*/
        
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


