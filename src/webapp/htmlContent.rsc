module webapp::htmlContent

// NOTE: This is where it is decided how the index file on browser should look like

import IO;
import util::Math;
import Type;

import webapp::jsContent;
import webapp::cssContent;

// defining html tags
public str tags(str operator, str attributes, str content) = "\<<operator><attributes>\>\n<content>\</<operator>\>\n";

public str tagsOneOperator(str operator, str attributes) = "\<<operator><attributes>\>\n";

// typical html tags
public str firsline() = "\<!DOCTYPE html\>\n";

public str html(str content) = tags("html", "", content);

public str title(str content) = tags("title", "", content);

public str header(str content) = tags("header", "", content);

public str body(str content) = tags("body", "", content);

// extra html tags 
public str ul(str attributes, str content) = tags("ul", attributes, content); 

public str li(str attributes, str content) = tags("li", attributes, content);

public str h2(str attributes, str content) = tags("h2", attributes, content);

public str h4(str attributes, str content) = tags("h4", attributes, content);

public str p(str attributes, str content) = tags("p", attributes, content);

public str form(str attributes, str content) = tags("form", attributes, content);

public str label(str attributes, str content) = tags("label", attributes, content);

public str textarea(str attributes, str content) = tags("textarea", attributes, content);

public str br() = "\<br\>\n";

public str input(str attributes, str content) = tags("input", attributes, content);

public str div(str attributes, str content) = tags("div", attributes, content);

// js tags
public str script(str attributes, str content) = tags("script", attributes, content);

public str textscript(str attributes, str content) = tags("script", attributes, content);

// css tags
public str link(str attributes) = tagsOneOperator("link", attributes);

public str style(str content) = tags("style", "", content);

// the index page with all the needed tags and attributes
public str htmlFilled(str expression, str userGram, map[int, map[str, list[str]]] gram) {
	str page = 
	firsline() + 
	html(
	header(
	title("Parse Tree Explorer") + style(cssFilled())) + 
	body(
	h2("", "P A R S E  T R E E - E X P L O R E R") + br() +
	form(" action=\"/submit\" method=\"GET\"", 
	label("","Text:") + br() + textarea(" id=\"text\"rows=\"2\" cols=\"30\" name=\"text\"", expression) + br() + 
	label("","Syntax/Grammar:") + br() + textarea(" id=\"grammar\"rows=\"14\" cols=\"30\" name=\"grammar\" 
	placeholder=\"Please define syntax/grammar with \'Expr\'.\n\nIf no syntax/grammar is defined, the expression will be defined with a concrete syntax with no layout.\"", userGram) + br() +
	input(" type=\"submit\" name=\"name\"","")) +
	p("", "\<b\>Examples for texts to try:\</b\> 1+2*3, 1+2*3+4*5+6, 1*2+3+4") +
	h4("", "\<b\> Current parse tree:\</b\>") +
	h4(" id=\"myBtn\"", expression) + 
	div(" id=\"viz\"","") + br() + 
	script(" src=\"https://d3js.org/d3.v3.min.js\"", "") + br() +
	script("", jsFilled(gram)) + br()
	)
	); // html ends
	
	return page;
}


