function filter(phrase, _id) {
 
   var words = phrase.value.toLowerCase().split(" ");
  
  var table = document.getElementById(_id);
  
  var ele, serial = 0;
 
   for (var r = 1; r < table.rows.length; r++) {
    
    ele = table.rows[r].innerHTML.replace(/<[^>]+>/g, "");
   
     var displayStyle = "none";

for (var i = 0; i < words.length; i++) {

   if ( words[i][0] != '!') {
       if (ele.toLowerCase().indexOf(words[i]) >= 0) {
          displayStyle = "";
       } else {
          displayStyle = "none";
          break;
        }
    } else {
        var word = words[i].split("!");
	if (word[1] != '') {
       if ( ele.toLowerCase().indexOf(word[1]) >= 0) {
          displayStyle = "none";
          break;
       } else {
          displayStyle = "";
        }    
	}
    }
}

	if ( displayStyle != "none" ) {
		serial += 1;
		if ( serial % 2 == 0) {
			table.rows[r].className = "odd";
		} else {
			table.rows[r].className = "even";
		}
		table.rows[r].cells[0].innerHTML = serial ;
	} 

       
 table.rows[r].style.display = displayStyle;
    
}
}

function footerClose() {
	var foot = document.getElementById("footer");
	foot.style.display = "none";
}
