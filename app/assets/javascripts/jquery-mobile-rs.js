(function() {
  $(function() {
    $(document).on("ice_cube_select:cancel ice_cube_select:save", ".ice_cube_select", function() {
      return $(this).selectmenu('refresh');
    });
    return $(document).on("ice_cube_select:dialog_opened", ".rs_dialog_holder", function() {
      $(this).find("select").attr("data-theme", $('.ice_cube_select').data("theme")).attr("data-mini", true).selectmenu();
      $(this).find("input[type=text]").textinput();
      return $(this).on("ice_cube_select:dialog_positioned", ".rs_dialog", function() {
        return $(this).css({
          "top": $(window).scrollTop() + "px"
        });
      });
    });
  });

}).call(this);
