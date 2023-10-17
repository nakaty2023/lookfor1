document.addEventListener('turbo:load', function() {
  document.addEventListener("input", function (event) {
    if (event.target.classList.contains("auto-expand")) {
      event.target.style.height = "inherit";
      const computed = window.getComputedStyle(event.target);
      const height = parseInt(computed.getPropertyValue("border-top-width"), 10)
                   + parseInt(computed.getPropertyValue("padding-top"), 10)
                   + event.target.scrollHeight
                   + parseInt(computed.getPropertyValue("padding-bottom"), 10)
                   + parseInt(computed.getPropertyValue("border-bottom-width"), 10);

      event.target.style.height = height + "px";
    }
  });
});
