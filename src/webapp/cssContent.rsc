module webapp::cssContent

public str css(str content) = "<content>";

public str cssFilled() = css(s);

str s = "html {
  text-align: center;
}
  
 .link {
    fill: none;
    stroke: #ccc;
    stroke-width: 3px;
  }
"
;