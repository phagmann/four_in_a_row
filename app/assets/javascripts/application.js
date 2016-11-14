// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


function getOffset( currDiv ) {
    var rect = currDiv.getBoundingClientRect();
    return {
        left: rect.left + window.pageXOffset,
        top: rect.top + window.pageYOffset,
        width: rect.width || currDiv.offsetWidth,
        height: rect.height || currDiv.offsetHeight
    };
}

function connect(div1, div2, color, thickness) { // draw a line connecting elements
    var off1 = getOffset(div1);
    var off2 = getOffset(div2);
    // bottom right
    var x1 = off1.left ;
    var y1 = off1.top ;
    // top right
    var x2 = off2.left ;
    var y2 = off2.top;
    // distance
    var length = Math.sqrt(((x2-x1) * (x2-x1)) + ((y2-y1) * (y2-y1))) + 300;
    // center
    var cx = ((x1 + x2) / 2) - (length / 2) + 25;
    var cy = ((y1 + y2) / 2) - (thickness / 2) + 25;
    // angle
    var angle = Math.atan2((y1-y2),(x1-x2))*(180/Math.PI);
    // make hr
    var htmlLine = "<div style='padding:0px; margin:0px; height:" + thickness + "px; background-color:" + color + "; line-height:1px; position:absolute ; left:" + cx + "px; top:" + cy + "px; width:" + length + "px; -moz-transform:rotate(" + angle + "deg); -webkit-transform:rotate(" + angle + "deg); -o-transform:rotate(" + angle + "deg); -ms-transform:rotate(" + angle + "deg); transform:rotate(" + angle + "deg);' />";
    //
    // alert(htmlLine);
    document.body.innerHTML += htmlLine;
}





function shutdown(curX,curY,row,col,num1,num2,data){
  for (var i = 1; i <= num1*num2; i++){

    var currentDivId = "g";
    currentDivId += i.toString(); 
    document.getElementById(currentDivId).disabled = true;


  }
  var origin=document.getElementById("g" + ((col)*data[col].length + (row+1)).toString()); 
  var end=document.getElementById("g" + ((curY)*data[curY].length + (curX+1)).toString()); 
  connect(origin, end, "blue", 20)
  return 
}


function datasArray(num1,num2){
  var d = [];
  var r =[];

  for (var ii = 1; ii <= num1*num2; ii++) {
    var currentDivId = "g";
    currentDivId += ii.toString();
    ////(currentDivId);
    var className = document.getElementById(currentDivId).getAttribute("class");
    if(className == "col-sm-5 egg" ) {
      
      r = r.concat(0);
     }
    else if(className == "col-sm-5 circle" ){
      
      r = r.concat(1);
       }
    else if(className == "col-sm-5 cross" ){
      
      r = r.concat(2);
       }
    
    if( ii % num1 == 0) {
      
      d= d.concat([r]);
      r = [];
}

    
};
//(d);
return d;
};


function ifWin(num1,num2){

    var data = datasArray(num1,num2);


  //stage 3: figures out if a player has won



  for ( var col = 0; col <= data[0].length - 1; col++){
    for ( var row = 0; row <= data.length -1; row++){
      var target = data[col][row];
      //var gDex = col*data[col].length + row
      if (target == 0){
        continue;
      }
      for ( var y = -1; y <= 1; y++){
        for ( var x = -1; x <= 1; x++){
          var curX= row + x;
          var curY= col + y;
          if (curX  >= 0 && curX < data.length  && curY  >= 0 && curY < data[0].length){
            if (data[curY][curX] == target  && !(x == 0 && y == 0) ){
              curX = curX + (curX - row);
              curY = curY + (curY - col);
          if (curX  >= 0 && curX < data.length  && curY  >= 0 && curY < data.length){
            if (data[curY][curX] == target && data[curY][curX]!= 0 && !(x == 0 && y == 0) ){
              curX = curX + (curX - row - x);
              curY = curY + (curY - col - y);

              if (curX  >= 0 && curX < data.length  && curY  >= 0 && curY < data[0].length){
                if (data[curY][curX] == target){
                  shutdown(curX,curY,row,col,num1,num2,data)
                  return 5
                 
      

                }

              }
              }
}
}
              }
             }
  


        }


      }


}

}
