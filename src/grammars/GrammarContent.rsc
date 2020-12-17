module grammars::GrammarContent

// NOTE: Not used

public str grammarFilled(str s, str grammar) {

	str content = "module grammars::UserGrammar\n\n"+
	//"//import ParseTree;\n//import demo::lang::Exp::Combined::Automatic::Parse;\n//import grammars::getGrammar;\n//import Map;\n\n" +
	grammar + "\n\n"; //+
	//"public map[int, map[str, str]] userGram(str text) {\n\tmapOfNodes = getTreeNodes(parse(#Expr, text));\n\treturn mapOfNodes;\n}";
	
	return content;
}

