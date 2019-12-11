$(function() {
  $('img.mini-image').mouseover(function(){
  // "_thumb"を削った画像ファイル名を取得
  var selectedSrc = $(this).attr('src').replace(/^(.+)(\.gif|\.jpg|\.png+)$/, "$1"+"$2");
  
  // 画像入れ替え
  $('img.main-image').stop().fadeOut(50,
  function(){
  $('img.main-image').attr('src', selectedSrc);
  $('img.main-image').stop().fadeIn(200);
  }
  );
  $(this).css({"opacity": "0.5" });
  });
  
  $('img.mini-image').mouseout(function(){
  $(this).css({"opacity":"1"});
  });
 });