module grammars::getGrammar

//import demo::lang::Exp::Concrete::WithLayout::Syntax;
import demo::lang::Exp::Concrete::NoLayout::Syntax;
//import demo::lang::Exp::Combined::Manual::Parse;
//import demo::lang::Exp::Combined::Automatic::Parse;
//import grammar::Expr;
import ParseTree;
import vis::Figure;
import vis::ParseTree;
import vis::Render;

import IO;
import Type;
import Map;

/*
lexical Whitespace = [\ \n];
layout MyLayout = Whitespace*;       // !>> [\ \n]
lexical NUM = [0-9]+;                 // !>> [0-9]
lexical Id = [a-z]+;                 // !>> [a-z];
// keyword Keyword = "if" | "else" | "then";
// lexical Name = Id \ Keyword;


syntax Expr
    = NUM 
    | Id Expr
    > left Expr "+" Expr
    > left Expr "*" Expr
    > left Expr "/" Expr
    | "("  Expr  ")"
    ;

   

lexical Expr2 // should be equivalent to Expr
    = NUM
    | Id MyLayout Expr2
    > left Expr2 MyLayout "+" MyLayout Expr2
    > left Expr2 MyLayout "*" MyLayout Expr2
    | "("  MyLayout Expr2  MyLayout ")"
    ;
   
*/
public map[int, map[str, str]] getTreeNodes(Tree t) {
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
            //println("<printSymbol(s, false)>: ‘<a>’");
            if (("<a>") != ("")) {
            	//println("<printSymbol(s, false)>: ‘<a>’");
	        	subdic = ("<printSymbol(s, false)>" : "<a>");
	            dic = dic + (i : subdic);
	            i = i + 1;
            }   
        }		
    }
    //println(dic);
    //return li;
    return dic;
}

void main() {
	//str ex = "4+5";
	//visParsetree(parse(#Exp, "1+2*3"));
	//printlnExp(parseExp(ex));
	//iprintln(parse(#Expr, "2+3*4"));
	//tree = parse(#Exp, "2+3*4");
	//iprintln(tree);
	//iprintln(#Exp.definitions);
	//parse(type(sort("Exp"), definitionsMap));
	//renderSave(visParsetree(parse(#Exp, "1+2*3")), |file:///Users/emilyminguyen/uib/7.semester/INF225/termproject/web-based-syntax-grammar-explorer/src/webapp/testerRender.png|);
	//mapOfNodes = getGrammar("1");
	//println(mapOfNodes);
	//a = makeNode("e", mapOfNodes);
	//println("heeer: ", a);
	
	//render(visParsetree(parseExp("1+2*3")));
	//render(visParsetree(parse(#Exp,"0+(1*2)")));
	
	//teste = getTreeNodes(parse(#Exp, "0+(1*2)"));
	//println(teste);
	
	//println(visParsetree(parse(#Exp, "1+2*3")));
	//visParsetree(parse(#Exp, "1+2*3"));
	//printExpressions(parse(#Expr, "1+2*3"));
}


