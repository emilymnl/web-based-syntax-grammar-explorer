module webapp::jsContent

import examples::Test;

import Map;
import IO;

import Type; 	//typeOf
import Set;
import List; 	// size
import String; 	//toInt contains


public str js(str content) = "<content>";

public str jsFilled(map[int, map[str, str]] gram) = js(first(gr(gram)) + rest());

// 3d.js
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
	
	for (int n <- [0 .. sizeMap]) { 	// 0 .. 10 // 9 .. (-1)
		if (sizeMap == 2) {				// if only one number (contains NUM and EXPR)
			str root = min(gram[n]<0>);	// only NUM
			str val = min(gram[n]<1>);	// only the integer
			
			return nameChildren("Program", children("<root>", child("<val>")));
		}
		else {							// an expression (longer than one number) e.g 1+2
			
		// FIRST  NUMBER
			if (n == 0) {
				// left
				//println("left: " + min(gram[n]<1>));
				mainLeft = createChildren(n, gram);
				left = mainLeft;
				
			} else {
			
		//OPERATOR and following number
				if (min(gram[n]<1>) == "+" || min(gram[n]<1>) == "*" || min(gram[n]<1>) == "/") {
					//println("operator: " + min(gram[n]<1>));
					
					// operator
					str val = min(gram[n]<1>);
					oper = child("<val>");		
					
					//right
					//println("right: " + min(gram[n+1]<1>));
					right = createChildren(n+1, gram);
				// MORE OPERATOR (is it the same oper or another one)
					if (min(gram[n+3]<1>) == "+" || min(gram[n+3]<1>) == "*" || min(gram[n+3]<1>) == "/") {
						
						//println("more operators: " + min(gram[n+3]<1>));
						li += left;
						operList += oper;

						left  = right;
						//println("first right, now left: " + min(gram[n+1]<1>));
						
				// NOT more operators (the  expression aka set together)
					} else { 
						// Set together
						//println("sub tree: " + min(gram[n+3]<1>));
						str expr = min(gram[n+3]<0>);
						if (n+3 != sizeMap-1) {	// everything except the last in map
							mainRight = children("<expr>", (left + "," + oper + "," + right));	 // { name: 'PlusExpr',  children: [ <children> ]\n}\n
							left = mainRight;
						} else {		// if expression is the last in map
							mainLeft = left;
							mainRight = right;
							//println("heeeeer");
						}
						c = 0;	// this count is useful for later
						
					}
		// NOT OPERATOR (number and expression) 
				} else {
					// NOT number NOR last expression - find the expressions only
					if ((contains((min(gram[n]<1>)), "+") || contains((min(gram[n]<1>)), "*") || contains((min(gram[n]<1>)), "/")) && n != sizeMap-1 ) { // et uttrykk
						// add subtree and subtree
						//println(min(gram[n]<1>)+" ---- got the expression!");
						c += 1;
						
						if (c==2) {
							c=0;
							//println(min(gram[n]<1>)+" ---- got the expression!");
							//println("set together AGAIN " + min(gram[n]<1>));
							str expr = min(gram[n]<0>);	
							oper = top(operList);
							right = left;
							left = top(li);
							mainRight = children("<expr>", (left + "," + oper + "," + right));	 // { name: 'PlusExpr',  children: [ <children> ]\n}\n
							left = mainRight;
							
							li = [] + left;
							//println(li);
						}
						
					}/* else { //no need for else here
						a;
					}*/
		// LAST EXPRESSION in map
					if (n == sizeMap-1) {
						//println(min(gram[n]<1>)+" ---- last expression!");
						str expr = min(gram[n]<0>);
						
						if (size(li) == 0) {
							result = nameChildren("Program",  children(expr, (mainLeft + "," + oper + "," + mainRight)));
							//println("list is empty");
						}  else {
								if (size(li) == 1) {	
									mainLeft = top(li);
									oper = top(operList);
									//println("only oneeeee");
									
								} else { // 2 or more in list
									mainLeft = top(li);
									oper = top(operList);
									//println("moreeeeeeee");
								}
							
							result = nameChildren("Program", children(expr, (mainLeft + "," + oper + "," + mainRight)));
							//println("took from list");
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

public str createChildren(int n, map[int, map[str, str]] gram) {	//n in list
	str name = min(gram[n]<0>);	
	str val = min(gram[n]<1>);
	return children("<name>", child("<val>"));

}


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
/*
function createTree() {
	var textInput = document.getElementById(\'myBtn\').textContent;
	console.log(textInput);
	return textInput;
}

function str myFunction() {
  var x = document.getElementById(\"myBtn\").value;
  document.getElementById(\"demo\").innerHTML = x;  
} */

";



