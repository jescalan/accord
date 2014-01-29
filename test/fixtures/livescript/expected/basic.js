(function(){
  var x;
  x = 10;
  (function(){
    return x = 5;
  })();
}).call(this);
