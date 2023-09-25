// 巨大画像のアップロードを防止する
document.addEventListener("turbo:load", function() {
  document.addEventListener("change", function(event) {
    let image_upload_shoppost = document.querySelector('#shoppost_images');
    let image_upload_user = document.querySelector('#user_image');

    let target_upload = null;
    if (event.target === image_upload_shoppost) {
      target_upload = image_upload_shoppost;
    } else if (event.target === image_upload_user) {
      target_upload = image_upload_user;
    }

    if (target_upload) {
      const size_in_megabytes = target_upload.files[0].size/1024/1024;
      if (size_in_megabytes > 5) {
        alert("画像のサイズは5MB以下である必要があります。");
        target_upload.value = "";
      }
    }
  });
});
