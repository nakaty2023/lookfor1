// 巨大画像のアップロードを防止する
document.addEventListener("turbo:load", function() {
  document.addEventListener("change", function(event) {
    let image_upload = document.querySelector('#shoppost_images');
    const size_in_megabytes = image_upload.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert("画像のサイズは5MB以下である必要があります。");
      image_upload.value = "";
    }
  });
});
