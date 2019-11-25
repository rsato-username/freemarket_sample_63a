$("turbolinks:load",function(){
  $(function() {
    let tabs = $("ul.mypage__tab li");
  
    function tabSwitch() {
      $("ul.mypage__tab li.active").removeClass("active");
      $(this).addClass("active");
      let index = tabs.index(this);
      $(".mypage__tab .tab-content ul").removeClass("show").eq(index).addClass("show");
    }

    tabs.click(tabSwitch);
  });

  $(function() {
    let tabs = $("ul.mypage__buy__tab li");
  
    function tabSwitch() {
      $("ul.mypage__buy__tab li.active").removeClass("active");
      $(this).addClass("active");
      let index = tabs.index(this);
      $(".mypage__buy .tab-content ul").removeClass("show").eq(index).addClass("show");
    }

    tabs.click(tabSwitch);
  });
});