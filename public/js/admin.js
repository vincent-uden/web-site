
getRouteStats();

function renderRouteStats(resp) {
    resp = JSON.parse(resp);
    let histDiv = document.getElementById("routeHistory");
    resp.map(x => addRouteRow(histDiv, x));
    let mostVisits = resp.reduce(((acc, curr) => Math.max(acc, curr.visits)), resp[0].visits)
    console.log(mostVisits);
    console.log(resp);
    for ( let i = 0; i < resp.length; i++ ) {
        histDiv.children[i].children[0].style.width = (resp[i].visits / mostVisits * 60) + "%";
    }
}

function addRouteRow(histDiv, row) {
    console.log(row.path);
    let rowDiv = document.createElement("div");
    rowDiv.classList.add("histRow");
    let text = document.createElement("p");
    text.innerHTML = row.path + ": " + row.visits;
    let bar = document.createElement("div");
    bar.classList.add("bar");
    bar.style.width = "60%";
    bar.style.height = "16px";
    rowDiv.appendChild(bar);
    rowDiv.appendChild(text);
    histDiv.appendChild(rowDiv);
}

function getRouteStats() {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if ( this.readyState == 4 && this.status == 200 ) {
            renderRouteStats(xhttp.responseText);
        }
    }

    xhttp.open("GET", "/admin/route_history", true);
    xhttp.send();
}
