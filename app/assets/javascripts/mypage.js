$("turbolinks:load",function(){
  // お知らせ・やることリスト部分
  $(function() {
    let tabs = $("ul.mypage__tab li");
  
    function tabSwitch() {
      $("ul.mypage__tab li.active").removeClass("active");
      $(this).addClass("active");
      let index = tabs.index(this);
      $(".mypage__tab .tab-content ul").removeClass("showbox").eq(index).addClass("showbox");
    }

    tabs.click(tabSwitch);
  });
  // 取引中・過去の取引部分
  $(function() {
    let tabs = $("ul.mypage__buy__tab li");
  
    function tabSwitch() {
      $("ul.mypage__buy__tab li.active").removeClass("active");
      $(this).addClass("active");
      let index = tabs.index(this);
      $(".mypage__buy .tab-content ul").removeClass("showbox").eq(index).addClass("showbox");
    }

    tabs.click(tabSwitch);
  });
  // 出品中・取引中・売却済み部分
  $(function() {
    let tabs = $("ul.myitem-status li");
  
    function tabSwitch() {
      $("ul.myitem-status li.active").removeClass("active");
      $(this).addClass("active");
      let index = tabs.index(this);
      $(".myitem .myitem-lists .myitem-list").removeClass("showbox").eq(index).addClass("showbox");
    }

    tabs.click(tabSwitch);
  });
});