// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

let userSelection = document.getElementsByClassName("sort");
let sortInput = document.getElementById("sort");
let scoreForm = document.getElementById("score-form");

for (let i = 0; i < userSelection.length; i++) {
    userSelection[i].addEventListener("click", sort);
}

function sort(event) {
    var targetElement = event.target || event.srcElement;
    sortInput.setAttribute("value", targetElement.id);
    scoreForm.submit();
}