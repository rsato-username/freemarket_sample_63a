
$(function(){
  $('#item_images').on('change', function(e) {
    var preview = $(".exhibit__container--form__image--preview");
    preview.empty();
    for (var i = 0, file; file = e.target.files[i]; i++) {
      var reader = new FileReader();
      reader.onload = (function() {
        return function(e) {
          preview.append($('<img>').attr({
            src: e.target.result,
          }));
        };
      })(file);
      reader.readAsDataURL(file);
    }
  });
});

// $(function(){
//   var array = [];
//   $('#item_images').on('change', function(e) {
//     var preview = $(".exhibit__container--form__image--preview");
//     preview.empty();
//     for (var i = 0, file; file = e.target.files[i]; i++) {
//       array.push(file);
//     }
//     for (var i = 0, f; f = array[i]; i++) {
//       var reader = new FileReader();
//       reader.onload = (function() {
//         return function(e) {
//           preview.append($('<img>').attr({
//             src: e.target.result,
//           }));
//         };
//       })();
//       reader.readAsDataURL(f);
//       // new FileUpload();
//     }
//   });
// });

