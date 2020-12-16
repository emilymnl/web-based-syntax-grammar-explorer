module webapp::jsContent

import examples::Test;

import Map;
import IO;

import Type; 	// typeOf
import Set;
import List; 	// size
import String; 	// toInt and contains


public str js(str content) = "<content>";

// the main one
public str jsFilled(map[int, map[str, str]] gram) = js(first(gr(gram)) + rest());

// for 3d.js
public str name(str name) = "name: \'<name>\'\n";

public str child(str name) = "{\n name: \'<name>\' \n}"; 

public str nameChildren(str name, str children) = "name: \'<name>\',\nchildren: [ <children> ]";

public str children(str name, str children) = "{\n name: \'<name>\',\nchildren: [ <children> ]\n}\n"; 


// functions
str gr(map[int, map[str, str]] gram) {
	str result = "";
	str mainRight = "";
	str mainLeft = "";
	str right = "";
	str oper = "";
	str left = "";
	
	int c = 0;
	
	list[str] li = [];
	list[str] operList = [];
	
	int sizeMap = size(gram);
	
	// 0 .. 10 // 9 .. (-1)
	for (int n <- [0 .. sizeMap]) {
		// if only one number (contains NUM and EXPR)	
		if (sizeMap == 2) {	
			// only NUM			
			str root = min(gram[n]<0>);
			// only the integer
			str val = min(gram[n]<1>);	
			
			return nameChildren("Program", children("<root>", child("<val>")));
		}
		// an expression (longer than one number) e.g 1+2
		else {							
			
		// FIRST  NUMBER
			if (n == 0) {
				// left
				println("left: " + min(gram[n]<1>));
				mainLeft = createChildren(n, gram);
				left = mainLeft;
			} else {
		//OPERATOR and following number
				if (min(gram[n]<1>) == "+" || min(gram[n]<1>) == "*" || min(gram[n]<1>) == "/") {
					// operator
					println("operator: " + min(gram[n]<1>));
					str val = min(gram[n]<1>);
					oper = child("<val>");		
					
					//right
					println("right: " + min(gram[n+1]<1>));
					right = createChildren(n+1, gram);
				// MORE OPERATOR 
					if (min(gram[n+3]<1>) == "+" || min(gram[n+3]<1>) == "*" || min(gram[n+3]<1>) == "/") {
						println("more operators: " + min(gram[n+3]<1>));
						li += left;
						operList += oper;

						left  = right;
						println("first right, now left: " + min(gram[n+1]<1>));
						
				// NOT more operators (the expression aka set together)
					} else { 
						// Set together
						println("sub tree: " + min(gram[n+3]<1>));
						str expr = min(gram[n+3]<0>);
						// expression is not the last in map
						if (n+3 != sizeMap-1) {
							mainRight = children("<expr>", (left + "," + oper + "," + right));	 // { name: 'PlusExpr',  children: [ <children> ]\n}\n
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
						c = 0;	
						
					}
		// NOT OPERATOR (number and expression) 
				} else {
					// NOT number NOR last expression - find the expressions only
					if ((contains((min(gram[n]<1>)), "+") || contains((min(gram[n]<1>)), "*") || contains((min(gram[n]<1>)), "/")) && n != sizeMap-1 ) { // et uttrykk
						// add sub tree and sub tree
						println(min(gram[n]<1>)+" ---- got the expression!");
						c += 1;
	
						if (c==2) {
							c=0;
							println(min(gram[n]<1>)+" ---- got the expression (the right)!");
							println("set together AGAIN " + min(gram[n]<1>));
							str expr = min(gram[n]<0>);	
							oper = top(operList);
							right = left;
							left = top(li);
							mainRight = children("<expr>", (left + "," + oper + "," + right));	 // { name: 'PlusExpr',  children: [ <children> ]\n}\n
							left = mainRight;
							
							li = [] + left;
							
						}
						
					}/* else { //no need for else here
						a;
					}*/
		// LAST EXPRESSION in map
					if (n == sizeMap-1) {
						println(min(gram[n]<1>)+" ---- last expression!");
						str expr = min(gram[n]<0>);
						
						if (size(li) == 0) {
							result = nameChildren("Program",  children(expr, (mainLeft + "," + oper + "," + mainRight)));
							println("list is empty");
						}  else {
								if (size(li) == 1) {	
									mainLeft = top(li);
									oper = top(operList);
									println("only one in list");
									
								} else {
									// take the last one in list
									mainLeft = last(li);
									oper = top(operList);
									//println(size(li));
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

// no need for this..yet
public str childrenAndChildren(str name, str oper, list[str] leftList)  {
	str left = "";
	
	for (f <- leftList) {
		if (f == leftList[0]) {
			left = f;
		} else {
			left = children(name, (left + "," + oper + "," + f));
		}
	}

	return left;
}

public str createChildren(int n, map[int, map[str, str]] gram) {	
	str name = min(gram[n]<0>);	
	str val = min(gram[n]<1>);
	return children("<name>", child("<val>"));

}

// not the best code but time is limited
str first(str grammatikk) = 
"
parseTree({
  divID: \'viz\',
  width: 600,
  height: 300,
  padding: 50,
  data: { <grammatikk> }
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



