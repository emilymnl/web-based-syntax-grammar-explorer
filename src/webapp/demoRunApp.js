
parseTree({
  divID: 'viz',
  width: 600,
  height: 300,
  padding: 50,
  data: { name: 'Program',
children: [ {
 name: 'Expr',
children: [ {
 name: 'Expr',
children: [ {
 name: 'NUM',
children: [ {
 name: '1' 
} ]
}
,{
 name: '+' 
},{
 name: 'NUM',
children: [ {
 name: '2' 
} ]
}
 ]
}
,{
 name: '*' 
},{
 name: 'Expr',
children: [ {
 name: 'NUM',
children: [ {
 name: '3' 
} ]
}
,{
 name: '+' 
},{
 name: 'NUM',
children: [ {
 name: '4' 
} ]
}
 ]
}
 ]
}
 ] }
})

function parseTree(o) {

  d3.select("#" + o.divID).select("svg").remove()

  var viz = d3.select("#" + o.divID)
    .append("svg")
    .attr("width", o.width)
    .attr("height", o.height)

  var vis = viz.append("g")
    .attr("id", "treeg")
    .attr("transform", "translate(" + o.padding + "," + o.padding + ")")

  var tree = d3.layout.tree()
    .size([o.width - (2 * o.padding), o.height - (2 * o.padding)]);

  var diagonal = d3.svg.diagonal()
    .projection(function(d) {
      return [d.x, d.y];
    });

  var nodes = tree.nodes(o.data);

  var link = vis.selectAll("pathlink")
    .data(tree.links(nodes)).enter()
    .append("path")
    .attr("class", "link")
    .attr("d", diagonal)

  var node = vis.selectAll("g.node")
    .data(nodes).enter()
    .append("g")
    .attr("transform", function(d) {
      return "translate(" + d.x + "," + d.y + ")";
    })

  node.append("circle")
    .attr("r", 10)
    .style("fill", function(d) {
      return (d.children) ? "#68A5BA" : "#A8C7D0"
    });
    
    d3.select("body")
    .style("background-color", "#F4F4F4");
    

  node.append("svg:text")
    .attr("dx", function(d) {
      return d.children ? 0 : 0;
    })
    .attr("dy", function(d) {
      return d.children ? 5 : 5;
    })
    .attr("text-anchor", function(d) {
      return d.children ? "middle" : "middle";
    })
    .style("fill", "black").text(function(d) {
      return d.name;
    })
}

function createTree() {
	var textInput = document.getElementById('text').value;
	console.log(textInput);
	return textInput;
	/*location.href = "file:///Users/emilyminguyen/uib/7.semester/INF225/termproject/web-based-syntax-grammar-explorer/src/webapp/demoRunAppp.html";
	*/
}
/*createTree();*/
