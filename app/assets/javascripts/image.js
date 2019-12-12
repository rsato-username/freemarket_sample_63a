$(document).on('turbolinks:load', function(){
  var dropzone = $('.dropzone-area');
  var photos = [];
  var inputs  =[];
  var input_area = $('.input_area');
  var preview = $('#preview');

  $(document).on('change', 'input[type= "file"].upload-image',function(event) {
    var file = $(this).prop('files')[0];
    var reader = new FileReader();
    inputs.push($(this));
    var img = $(`<div class= "img_view"><img></div>`);
    reader.onload = function(e) {
      var btn_wrapper = $('<div class="btn_wrapper"><div class="btn edit">編集</div><div class="delete">削除</div></div>');
      img.append(btn_wrapper);
      img.find('img').attr({
        src: e.target.result
      })
    }
    reader.readAsDataURL(file);
    photos.push(img);

    $('#preview').empty();
    $.each(photos, function(index, photo) {
      photo.attr('data-image', index);
      preview.append(photo);
      dropzone.css({
        'width': 'calc(100% - (135px * ${photos.length}))'
      })
    })

    img.css({
      'width': `calc(100% - (135px * ${photos.length}))`
    });

    // var new_photo = $(`<input multiple= "multiple" name="photos[url][]" class="upload-image" data-image= ${photos.length} type="file" id="upload-image">`);
    var new_photo = $(`<input multiple= "multiple" name="photos[url][]" id="upload-image" class="upload-image" data-image= ${photos.length} type="file"></input>`);
    input_area.prepend(new_photo);
  });

  $(document).on('click', '.delete', function() {
    var target_photo = $(this).parent().parent();
    $.each(inputs, function(index, inputs){
      if ($(this).data('image') == target_photo.data('image')){
        $(this).remove();
        target_photo.remove();
        var num = $(this).data('image');
        photos.splice(num, 1);
        inputs.splice(num, 1);
        if(inputs.length == 0) {
          $('input[type= "file"].upload-image').attr({
            'data-image': 0
          })
        }
      }
    })
    $('input[type= "file"].upload-image:first').attr({
      'data-image': inputs.length
    })
    $.each(inputs, function(index, input) {
      var input = $(this)
      input.attr({
        'data-image': index
      })
      $('input[type= "file"].upload-image:first').after(input)
    })

    $.each(photos, function(index, photo) {
      photo.attr('data-image', index);
      preview.append(photo);
    })
    dropzone.css({
      'width': `calc(100% - (135px * ${images.length}))`
    })
  });

});