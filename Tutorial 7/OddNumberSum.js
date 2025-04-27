function calculateOddSum() {
  const min = parseInt(document.getElementById("minValue").value);
  const max = parseInt(document.getElementById("maxValue").value);
  
  let sum = 0;
  let oddNumbers = [];
  
  for (let i = min; i <= max; i++) {
    if (i % 2 !== 0) {
      sum += i;
      oddNumbers.push(i);
    }
  }
  
  document.getElementById("result").innerHTML = 
    `${oddNumbers.join(" + ")} = ${sum}`;
}
  