$("turbolinks:load",function(){

  $("#ladiesbtn").click(function(){
    var position1 = $("#topladies").offset().top;
    $("html,body").animate({
      scrollTop : position1 // さっき変数に入れた位置まで
    }, {
      queue : false // どれくらい経過してから、アニメーションを始めるか。キュー[待ち行列]。falseを指定すると、キューに追加されずに即座にアニメーションを実行。
    });
  });

  $("#mensbtn").click(function(){
    var position2 = $("#topmens").offset().top;
    $("html,body").animate({
      scrollTop : position2
    }, {
      queue : false
    });
  });

  $("#kadensbtn").click(function(){
    var position3 = $("#topkadens").offset().top;
    $("html,body").animate({
      scrollTop : position3
    }, {
      queue : false
    });
  });

  $("#toysbtn").click(function(){
    var position4 = $("#toptoys").offset().top;
    $("html,body").animate({
      scrollTop : position4
    }, {
      queue : false
    });
  });

  $("#chanelsbtn").click(function(){
    var position5 = $("#topchanels").offset().top;
    $("html,body").animate({
      scrollTop : position4
    }, {
      queue : false
    });
  });

  $("#vuittonsbtn").click(function(){
    var position6 = $("#topvuittons").offset().top;
    $("html,body").animate({
      scrollTop : position6
    }, {
      queue : false
    });
  });

  $("#supsbtn").click(function(){
    var position7 = $("#topsups").offset().top;
    $("html,body").animate({
      scrollTop : position7
    }, {
      queue : false
    });
  });

  $("#nikesbtn").click(function(){
    var position8 = $("#topnikes").offset().top;
    $("html,body").animate({
      scrollTop : position8
    }, {
      queue : false
    });
  });

});