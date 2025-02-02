(function() {
  var $, methods;

  $ = jQuery;

  $(function() {
    $(document).on("focus", ".ice_cube_select", function() {
      return $(this).ice_cube_select('set_initial_values');
    });
    return $(document).on("change", ".ice_cube_select", function() {
      return $(this).ice_cube_select('changed');
    });
  });

  methods = {
    set_initial_values: function() {
      this.data('initial-value-hash', this.val());
      return this.data('initial-value-str', $(this.find("option").get()[this.prop("selectedIndex")]).text());
    },
    changed: function() {
      if (this.val() === "custom") {
        methods.open_custom.apply(this);
        return setModalTabbing();
      } else {
        return methods.set_initial_values.apply(this);
      }
    },
    open_custom: function() {
      this.data("recurring-select-active", true);
      new IceCubeSelectDialog(this);
      return this.blur();
    },
    save: function(new_rule) {
      var new_json_val;
      this.find("option[data-custom]").remove();
      new_json_val = JSON.stringify(new_rule.hash);
      if ($.inArray(new_json_val, this.find("option").map(function() {
        return $(this).val();
      })) === -1) {
        methods.insert_option.apply(this, [new_rule.str, new_json_val]);
      }
      this.val(new_json_val);
      methods.set_initial_values.apply(this);
      return this.trigger("ice_cube_select:save");
    },
    current_rule: function() {
      return {
        str: this.data("initial-value-str"),
        hash: $.parseJSON(this.data("initial-value-hash"))
      };
    },
    cancel: function() {
      this.val(this.data("initial-value-hash"));
      this.data("recurring-select-active", false);
      return this.trigger("ice_cube_select:cancel");
    },
    insert_option: function(new_rule_str, new_rule_json) {
      var new_option, separator;
      separator = this.find("option:disabled");
      if (separator.length === 0) {
        separator = this.find("option");
      }
      separator = separator.last();
      new_option = $(document.createElement("option"));
      new_option.attr("data-custom", true);
      if (new_rule_str.substr(new_rule_str.length - 1) !== "*") {
        new_rule_str += "*";
      }
      new_option.text(new_rule_str);
      new_option.val(new_rule_json);
      return new_option.insertBefore(separator);
    },
    setModalTabbing: function() {
      var tabbables;
      tabbables = $('#ice_cube_select_modal').find(':tabbable');
      $('#ice_cube_select_modal').off('keydown').on('keydown', function(e) {
        var x;
        var x;
        if ($(e.target).is(tabbables.first()) && e.which === 9 && e.shiftKey) {
          e.preventDefault();
          x = tabbables.last();
          x.focus();
        } else if ($(e.target).is(tabbables.last()) && e.which === 9 && !e.shiftKey) {
          e.preventDefault();
          x = tabbables.first();
          x.focus();
        }
      });
    };
    methods: function() {
      return methods;
    }
  };

  $.fn.ice_cube_select = function(method) {
    if (method in methods) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else {
      return $.error("Method " + method + " does not exist on jQuery.ice_cube_select");
    }
  };

  $.fn.ice_cube_select.options = {
    monthly: {
      show_week: [true, true, true, true, false, false]
    }
  };

  $.fn.ice_cube_select.texts = {
    locale_iso_code: "en",
    repeat: "Repeat",
    last_day: "Last Day",
    frequency: "Frequency",
    daily: "Daily",
    weekly: "Weekly",
    monthly: "Monthly",
    yearly: "Yearly",
    every: "Every",
    days: "day(s)",
    weeks_on: "week(s) on",
    months: "month(s)",
    years: "year(s)",
    day_of_month: "Day of month",
    day_of_week: "Day of week",
    cancel: "Cancel",
    ok: "OK",
    summary: "Summary",
    first_day_of_week: 0,
    days_first_letter: ["S", "M", "T", "W", "T", "F", "S"],
    order: ["1st", "2nd", "3rd", "4th", "5th", "Last"],
    show_week: [true, true, true, true, false, false]
  };

}).call(this);
