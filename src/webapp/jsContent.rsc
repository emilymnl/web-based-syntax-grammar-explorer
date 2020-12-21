module webapp::jsContent

// NOTE: This is where it is decided how the tree should look like

import Map;
import IO;

import Type;	
import Set;		
import List;	
import String;	

public str js(str content) = "<content>";

// the main one
public str jsFilled(map[int, map[str, list[str]]] gram) = js(first(gr(gram)) + rest());

// for 3d.js
public str name(str name) = "name: \'<name>\'\n";

public str child(str name) = "{\n name: \'<name>\' \n}"; 

public str nameChildren(str name, str children) = "name: \'<name>\',\nchildren: [ <children> ]";

public str children(str name, str children) = "{\n name: \'<name>\',\nchildren: [ <children> ]\n}\n"; 

// where the fun starts
str gr(map[int, map[str, list[str]]] gram) {
	str result = "";
	str mainRight = "";
	str mainLeft = "";
	str right = "";
	str oper = "";
	str left = "";
	
	int counter = 0;
	int parCount = 1;
	
	list[str] li = [];
	list[str] operList = [];
	
	int sizeMap = size(gram);
	
	for (int n <- [0 .. sizeMap]) {
		// if only one terminal
		if (sizeMap == 2) {	
			// only the lexical symbol (non-terminal)	
			str root = min(gram[n]<1>)[0];
			// only the terminal
			str val = min(gram[n]<1>)[1];
			
			return nameChildren("Program", children("<root>", child("<val>")));
		}
		// an expression (longer than one terminal) e.g 1+2
		else {							
		// FIRST terminal
			if (n == 0 && (min(gram[n]<0>) == "lit" ||  min(gram[n]<0>) == "lex")) {
				// left 
				println("left: " + min(gram[n]<1>)[1]);
				mainLeft = createChildren(n, gram);
				left = mainLeft;
				
				// if there are parantheses, and lots of them - go through them and find new left
				while (min(gram[n+parCount]<0>) == "lit" ||  min(gram[n+parCount]<0>) == "lex") {
					if (min(gram[n+parCount]<1>) != min(gram[n]<1>)) {
						println("new left: " + min(gram[n+parCount]<1>)[1]);
						println(parCount);
						mainLeft = createChildren(n+parCount, gram);
						left = mainLeft;
					} 
					parCount += 1;
					// there must be a limit of how many parantheses there can be
					if (parCount == 10) { 
						println("Break: " + min(gram[n+parCount]<1>)[1]);
						break;
					}
				}
			} else {
		//Literal (and following terminal)
				if (min(gram[n]<0>) == "lit" && (min(gram[n+1]<0>) == "lit" || min(gram[n+1]<0>) == "lex") && min(gram[n+1]<1>) != min(gram[n]<1>) && !(min(gram[n]<1>)[1] == "(") ) {
				
					// operator
					println("literal: " + min(gram[n]<1>)[1]);
					str val = min(gram[n]<1>)[1];
					oper = child("<val>");
					operList += oper;
				
					//right
					println("right: " + min(gram[n+1]<1>)[1]);
					right = createChildren(n+1, gram);
					
				// MORE Literals 
					if (min(gram[n+3]<0>) == "lit" && (min(gram[n+4]<0>) == "lit" || min(gram[n+4]<0>) == "lex")) {
						println("more literals: " + min(gram[n+3]<1>)[1]);
						li += left;
						operList += oper;

						left  = right;
						println("first right, now left: " + min(gram[n+1]<1>)[1]);
						
						counter = 0;
						
				// Non-Terminals (aka set together)
					} else { 
						// Set together
						println("sub tree: " + min(gram[n+3]<1>)[1]);
						str expr = min(gram[n+3]<1>)[0];
						
						// expression is not the last in map
						if (n+3 != sizeMap-1) {
							mainRight = children("<expr>", (left + "," + oper + "," + right));
							left = mainRight;
							
						// if expression is the last in map
						} else {
							mainLeft = left;
							mainRight = right;
							println("last expression, returns it");
							result = nameChildren("Program", children(expr, (mainLeft + "," + oper + "," + mainRight)));
							return result;
						}
						// this count is useful for later
						counter = 0;
					}
					
		// Not Literals (non-terminals) 
				} else {
					// non-literals but also not the last in map
					if ((min(gram[n]<0>) == "sort") && n != sizeMap-1 ) {
					
						// add sub-tree and sub-tree
						println(min(gram[n]<1>)[0] + " " + min(gram[n]<1>)[1] + " ---- got the non-terminal!");
						// counting how many expressions has surpassed this place
						counter += 1;
	
						if (counter == 3) {
							counter = 0;
							println("set together sub-trees: " + min(gram[n]<1>)[1]);
							str expr = min(gram[n]<1>)[0];	
							oper = top(operList);
							right = left;
							left = top(li);
							mainRight = children("<expr>", (left + "," + oper + "," + right));
							
							left = mainRight;
							li = [] + left;
							
						}
						
		// Parantheses
					} else { 
						if ((min(gram[n]<0>) == "par")) {
							println("got the the parenteses: ");
							println(min(gram[n]<1>));
							
							str expr = min(gram[n]<1>)[1];
							// middle
							middle = left;
							// right
							rightPar = min(gram[n]<1>)[2];
							rightt = children("<rightPar>", child("<rightPar>"));
							// left
							leftPar = min(gram[n]<1>)[0];
							leftt = children("<leftPar>", child("<leftPar>"));
							
							mainRight = children("<expr>", (leftt + "," + middle + "," + rightt));
							left = mainRight;
							li = [] + left;
							
							if (n+1 == sizeMap-1) {
								result = nameChildren("Program", mainRight);
								println("last expression, and with paranthese");
								return result;
							}
							// if we have come this far, we start from zero
							counter = 0;
						}
					}
		// LAST non-terminal in map
					if (n == sizeMap-1) {
						println(min(gram[n]<1>)[1] + " ---- last non-terminal!");
						str expr = min(gram[n]<1>)[0];
						if (size(li) == 0) {
							result = nameChildren("Program",  children(expr, (mainLeft + "," + oper + "," + mainRight)));
							println("list is empty");
						}  else {
							if (size(li) == 1) {
								mainLeft = last(li);
								oper = top(operList);
								println("only one in list");
							} else {
								// take the most recent one in list
								mainLeft = last(li);
								oper = top(operList);
								println("more in list");
							}
							result = nameChildren("Program", children(expr, (mainLeft + "," + oper + "," + mainRight)));
							println("took from list");
						}
					}
				}
			}
		}
		
	} 
	return result;
}

public str createChildren(int n, map[int, map[str, list[str]]]  gram) {	
	str name = min(gram[n]<1>)[0];	
	str val = min(gram[n]<1>)[1];
	return children("<name>", child("<val>"));

}

// not the best implementation but time is limited
str first(str treeGrammars) = 
"
parseTree({
  divID: \'viz\',
  width: 600,
  height: 300,
  padding: 50,
  data: { <treeGrammars> }
})
";

str rest() = 
"
function parseTree(o) {

  d3.select(\"#\" + o.divID).select(\"svg\").remove()

  var viz = d3.select(\"#\" + o.divID)
    .append(\"svg\")
    .attr(\"width\", o.width)
    .attr(\"height\", o.height)

  var vis = viz.append(\"g\")
    .attr(\"id\", \"treeg\")
    .attr(\"transform\", \"translate(\" + o.padding + \",\" + o.padding + \")\")

  var tree = d3.layout.tree()
    .size([o.width - (2 * o.padding), o.height - (2 * o.padding)]);

  var diagonal = d3.svg.diagonal()
    .projection(function(d) {
      return [d.x, d.y];
    });

  var nodes = tree.nodes(o.data);

  var link = vis.selectAll(\"pathlink\")
    .data(tree.links(nodes)).enter()
    .append(\"path\")
    .attr(\"class\", \"link\")
    .attr(\"d\", diagonal)

  var node = vis.selectAll(\"g.node\")
    .data(nodes).enter()
    .append(\"g\")
    .attr(\"transform\", function(d) {
      return \"translate(\" + d.x + \",\" + d.y + \")\";
    })

  node.append(\"circle\")
    .attr(\"r\", 10)
    .style(\"fill\", function(d) {
      return (d.children) ? \"#68A5BA\" : \"#A8C7D0\"
    });
    
    d3.select(\"body\")
    .style(\"background-color\", \"#F4F4F4\");
    

  node.append(\"svg:text\")
    .attr(\"dx\", function(d) {
      return d.children ? 0 : 0;
    })
    .attr(\"dy\", function(d) {
      return d.children ? 5 : 5;
    })
    .attr(\"text-anchor\", function(d) {
      return d.children ? \"middle\" : \"middle\";
    })
    .style(\"fill\", \"black\").text(function(d) {
      return d.name;
    })
}

";
