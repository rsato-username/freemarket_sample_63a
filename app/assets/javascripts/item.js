$(document).on('turbolinks:load', function(){
  $('.slick').slick({
    autoplay:true,
    dots:true,
  });
});

//販売手数料を計算するためのjs-----------------------------
$(function() {
$("#price").on("keyup", function() {
var input = $("#price").val();

if (input >= 300 && input <= 9999999) {
var number = Number(input);

t = number / 10;
te = Math.round(t);
r = number * 0.9;
ri = Math.round(r);
tesuryo = te.toLocaleString();
rieki = ri.toLocaleString();

$('p#pa').html('<p>¥</p>');
$('p#p').html(tesuryo);
$('p#pb').html('<p>¥</p>');
$('p#pp').html(rieki);
}else{
$('p#pa').html('<p></p>');
$('p#p').html('-');
$('p#pb').html('<p></p>');
$('p#pp').html('-');
}

});
});