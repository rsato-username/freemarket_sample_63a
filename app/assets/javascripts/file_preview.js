
$(function(){
  $('#item_images').on('change', function(e) {
    for (var i = 0, file; file = e.target.files[i]; i++) {
      // file = e.target.files[0]
      reader = new FileReader(),
      $preview = $(".exhibit__container--form__image--preview");
      reader.onload = (function(file) {
        return function(e) {
          $preview.empty();
          $preview.append($('<img>').attr({
            src: e.target.result,
            width: "20%",
            // class: "preview",
            title: file.name
          }));
        };
      })(file);
      reader.readAsDataURL(file);
    }
  });
});

