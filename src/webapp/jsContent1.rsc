module webapp::jsContent1

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



str gr(map[int, map[str, str]] gram) {
	str result = "";
	str mainRight = "";
	str mainLeft = "";
	str right = "";
	str oper = "";
	str left = "";
	
	int c = 0;
	
	list[str] leftList = [];
	
	int sizeMap = size(gram);
	
	for (int n <- [0 .. sizeMap]) { 	// 0 .. 10 // 9 .. (-1)
		if (sizeMap == 2) {				// kun ett tall (NUM og EXPR)
			str root = min(gram[n]<0>);	// [0] and then only NUM
			str val = min(gram[n]<1>);	// [0] and then only the integer
			
			return nameChildren("<root>", child("<val>"));
		}
		else {					// flere enn ett tall
			
			tallet = gram[n]<1>;
			exp = gram[n]<0>;
			
			if (n == 0) {
				//left
				/*
				str lroot = min(gram[n]<0>);	
				str lval = min(gram[n]<1>);
				left = children("<lroot>", child("<lval>")); // { name: 'NUM',  children: [ <{\n name: \'<name>\' \n}> ]\n}\n
				*/
				println("left: " + min(gram[n]<1>));
				left = createChildren(n, gram);
				
			} else {
				if (min(gram[n]<1>) == "+" || min(gram[n]<1>) == "*" || min(gram[n]<1>) == "/") {
					println("operatorrr " + min(gram[n]<1>));
					
					//middle
					str val = min(gram[n]<1>);
					oper = child("<val>");						// {\n name: \'<name>\' \n}
					
					//right
					/*
					str rroot = min(gram[n+1]<0>);	
					str rval = min(gram[n+1]<1>);
					right = children("<rroot>", child("<rval>")); // { name: NUM',  children: [ <{\n name: \'<name>\' \n}> ]\n}\n
					*/
					println("right: " + min(gram[n+1]<1>));
					right = createChildren(n+1, gram);
					
					if (min(gram[n+3]<1>) == "+" || min(gram[n+3]<1>) == "*" || min(gram[n+3]<1>) == "/") {
						//println(min(gram[n+7]<1>));
						if (min(gram[n+3]<1>) == val) {
							println("inside more operators: " + min(gram[n+]<1>));
						}
						
						println("more operators: " + min(gram[n+3]<1>));
						
						leftList += left;
						//left
						/*
						str lroot = min(gram[n+1]<0>);	
						str lval = min(gram[n+1]<1>);
						left = children("<lroot>", child("<lval>")); // { name: 'NUM',  children: [ <{\n name: \'<name>\' \n}> ]\n}\n
						*/
						left = createChildren(n+1, gram);
						println("left: " + min(gram[n+1]<1>));
						
						//continue;
					} else {
						//set together oof
						
						println("set together " + min(gram[n+3]<1>));
						str expr = min(gram[n+3]<0>);	
						mainRight = children("<expr>", (left + "," + oper + "," + right));	 // { name: 'PlusExpr',  children: [ <children> ]\n}\n
						left = mainRight;
						c = 0;
						//right =  mainRight;    /////her
						//println(left);
						
						
					}
					
				} else {
					println(n);
					//println(sizeMap-1);
					println();
					//if ((min(gram[n]<1>) != "+" && min(gram[n]<1>) != "*" && min(gram[n]<1>) != "/")) {	// ikke operatører + ikke den siste
						if ((contains((min(gram[n]<1>)), "+") || contains((min(gram[n]<1>)), "*") || contains((min(gram[n]<1>)), "/")) && n != sizeMap-1 ) { // et uttrykk
						//!equivalent(typeOf(toInt(min(gram[n]<1>))), typeOf(1))
							println(min(gram[n]<1>)+" ---- got you!");
							
							
							c += 1;
							println(c);
							println();
							if (c==2) {
								c=0;
								
								
								//println();
								
								println("set together AGAIN " + min(gram[n]<1>));
								str expr = min(gram[n]<0>);	
								str oper = min(gram[n]<1>);
								oper = child("<"*">");	//////////fix
								right = left;
								left = top(leftList);
								mainRight = children("<expr>", (left + "," + oper + "," + right));	 // { name: 'PlusExpr',  children: [ <children> ]\n}\n
								left = mainRight;
								
								leftList = [] + left;
								println(leftList);
						
								/*
								println(left);
								println();
								println();
								println(right);
								println();
								println();
								println(top(leftList));
								*/
								//println(top(leftList));
							}
						//}
					} //else {
		
					// siste
					if (n == sizeMap-1) {
				
						// put together with main rooooot
						str expr = min(gram[n]<0>);
						str op = "*";
						op = child("<op>");
						/*
						for (f <- l) {
							mainLeft += f + ",";
						}
						*/
						//println(size(l));
						//println(expr+" -----");
						
						/*mainLeft = childrenAndChildren(expr, op, leftList);*/
						
						//print(mainLeft);
						//println(ok);
						//int s = size(leftList);
						
						if (size(leftList) == 0) {
							result = nameChildren("Program", (mainLeft + mainRight));
							println("list is empty");
						} else {
							if (size(leftList) == 1) {	
								mainLeft = top(leftList);
								println("only oneeeee");
								mainRight = right;    ////   
								
							} else { // 2 or more in list
								//mainLeft = childrenAndChildren(expr, op, leftList);
								mainLeft = top(leftList);
								println(leftList);
								println("moreeeeeeee");
							}
							result = nameChildren("Program", children(expr, (mainLeft + "," + op + "," + mainRight)));
							println("took from list");
							
							
							println(left);
							println();
							println();
							println(right);
							println();
							println();
							
							//println(mainRight);
							//println(mainight);
							
						}
						//}
					}
				}
			}
			
		}
		
		//result += "<n>";
	}
	return result;
}

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
	str root = min(gram[n]<0>);	
	str val = min(gram[n]<1>);
	return children("<root>", child("<val>"));

}

/*

	"
	name: \'MultExpr\',
	children: [{
	  name: \'PlusExpr\',
	  children: [{
	    name: \'NUM\',
	    children: [{
	    	name: \'1\'
	    }]
	  }, 
	  
	  	{
	    name: \'\"+\"\'
	  }, 
	  
	  	{
	  	name: \'NUM\',
	    children: [{
	    	name: \'2\'
	    }]
	  }
	  
	  ]
	}
	
	, {
	  name: \'\"*\"\'
	    },{
	  name: \'NumExpr\',
	  children: [{
	  	name: \'NUM\',
	    children: [{
	    	name: \'3\'
	    }]
	  }]
	}]
	"

*/

str first(str grammatikk) = 
"
drawTree({
  divID: \'viz\',
  width: 600,
  height: 300,
  padding: 50,
  treeData: { <grammatikk> }
})
";

str rest() = 
"
function drawTree(o) {

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

  var nodes = tree.nodes(o.treeData);

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
      return (d.children) ? \"#E14B3B\" : \"#1C8B98\"
    });

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

function createTree() {
	var textInput = document.getElementById(\'text\').value;
	console.log(textInput);
	return textInput;
	/*location.href = \"file:///Users/emilyminguyen/uib/7.semester/INF225/termproject/web-based-syntax-grammar-explorer/src/webapp/demoRunAppp.html\";
	*/
}
/*createTree();*/
";



