$(document).ready(() => {
  $(".is-flash-delete-button").click(() => {
    $(event.currentTarget).closest(".flash-container").remove();
  });
});
