module grammars::GrammarContent

public str grammarFilled(str s, str grammar) {

	str content = "module grammars::UserGrammar\n\nimport ParseTree;\n//import demo::lang::Exp::Combined::Automatic::Parse;\nimport grammars::getGrammar;\nimport Map;\n\n" +
	grammar + "\n\n" +
	"public map[int, map[str, str]] userGram(str text) {\n\tmapOfNodes = getTreeNodes(parse(#Expr, text));\n\treturn mapOfNodes;\n}";
	
	return content;
}

