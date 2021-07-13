/*function getHello() {
    const url = 'http://localhost:5000'
    const response = fetch(url)
    response = response.json()
    console.log(response);
    document.getElementById("diploma").innerHTML = response;
}
*/

/*
let url = 'http://localhost:5000';

fetch(url)
.then(res => res.json())
.then((out) => {
  console.log('Checkout this JSON! ', out);
})
.catch(err => { throw err });
*/


function getHello() {
    const url = 'http://back-service:5000'
    fetch(url)
    .then(response => response.json())
//    const response = fetch(url)
//   const obj = JSON.parse(response)
    .then((out) => {
    console.log(out);
    var ov = JSON.stringify(out,null, "    ")
    document.getElementById("diploma").innerHTML = ov
//    out.confirmed + "," + out.country_code + "," + out.date_value + "," + out.country_code + "," + out.confirmed + "," + out.deaths + "," + out.stringency_actual + "," + out.stringency;
    })
}