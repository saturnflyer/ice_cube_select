// IceCubeSelect - Vanilla JS implementation
// Replaces the jQuery plugin version

(function() {
  'use strict';

  class IceCubeSelect {
    constructor(element) {
      this.element = element;
      this.bindEvents();
    }

    bindEvents() {
      this.element.addEventListener('focus', () => this.setInitialValues());
      this.element.addEventListener('change', () => this.changed());
    }

    setInitialValues() {
      this.element.dataset.initialValueHash = this.element.value;
      const selectedOption = this.element.options[this.element.selectedIndex];
      this.element.dataset.initialValueStr = selectedOption ? selectedOption.text : '';
    }

    changed() {
      if (this.element.value === 'custom') {
        this.openCustom();
        IceCubeSelect.setModalTabbing();
      } else {
        this.setInitialValues();
      }
    }

    openCustom() {
      this.element.dataset.recurringSelectActive = 'true';
      new IceCubeSelectDialog(this.element);
      this.element.blur();
    }

    save(newRule) {
      // Remove existing custom options
      const customOptions = this.element.querySelectorAll('option[data-custom]');
      customOptions.forEach(opt => opt.remove());

      const newJsonVal = JSON.stringify(newRule.hash);

      // Check if this value already exists
      const existingValues = Array.from(this.element.options).map(opt => opt.value);
      if (!existingValues.includes(newJsonVal)) {
        this.insertOption(newRule.str, newJsonVal);
      }

      this.element.value = newJsonVal;
      this.setInitialValues();
      this.element.dispatchEvent(new CustomEvent('ice_cube_select:save'));
    }

    currentRule() {
      const hashValue = this.element.dataset.initialValueHash;
      return {
        str: this.element.dataset.initialValueStr,
        hash: hashValue ? JSON.parse(hashValue) : null
      };
    }

    cancel() {
      this.element.value = this.element.dataset.initialValueHash;
      this.element.dataset.recurringSelectActive = 'false';
      this.element.dispatchEvent(new CustomEvent('ice_cube_select:cancel'));
    }

    insertOption(newRuleStr, newRuleJson) {
      // Find the separator (last disabled option, or last option)
      let separator = this.element.querySelector('option:disabled:last-of-type');
      if (!separator) {
        const options = this.element.querySelectorAll('option');
        separator = options[options.length - 1];
      }

      const newOption = document.createElement('option');
      newOption.dataset.custom = 'true';

      if (!newRuleStr.endsWith('*')) {
        newRuleStr += '*';
      }
      newOption.textContent = newRuleStr;
      newOption.value = newRuleJson;

      separator.parentNode.insertBefore(newOption, separator);
    }

    static setModalTabbing() {
      const modal = document.getElementById('ice_cube_select_modal');
      if (!modal) return;

      const tabbables = modal.querySelectorAll(
        'a[href], button, textarea, input, select, [tabindex]:not([tabindex="-1"])'
      );
      if (tabbables.length === 0) return;

      const firstTabbable = tabbables[0];
      const lastTabbable = tabbables[tabbables.length - 1];

      modal.addEventListener('keydown', function(e) {
        if (e.key !== 'Tab') return;

        if (e.shiftKey && document.activeElement === firstTabbable) {
          e.preventDefault();
          lastTabbable.focus();
        } else if (!e.shiftKey && document.activeElement === lastTabbable) {
          e.preventDefault();
          firstTabbable.focus();
        }
      });
    }

    // Get instance from element
    static getInstance(element) {
      return element._iceCubeSelect;
    }

    // Initialize or get instance
    static getOrCreate(element) {
      if (!element._iceCubeSelect) {
        element._iceCubeSelect = new IceCubeSelect(element);
      }
      return element._iceCubeSelect;
    }
  }

  // Static configuration
  IceCubeSelect.options = {
    monthly: {
      show_week: [true, true, true, true, false, false]
    }
  };

  IceCubeSelect.texts = {
    locale_iso_code: 'en',
    repeat: 'Repeat',
    last_day: 'Last Day',
    frequency: 'Frequency',
    daily: 'Daily',
    weekly: 'Weekly',
    monthly: 'Monthly',
    yearly: 'Yearly',
    every: 'Every',
    days: 'day(s)',
    weeks_on: 'week(s) on',
    months: 'month(s)',
    years: 'year(s)',
    day_of_month: 'Day of month',
    day_of_week: 'Day of week',
    cancel: 'Cancel',
    ok: 'OK',
    summary: 'Summary',
    first_day_of_week: 0,
    days_first_letter: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
    order: ['1st', '2nd', '3rd', '4th', '5th', 'Last'],
    show_week: [true, true, true, true, false, false]
  };

  // Auto-initialize on DOM ready and handle dynamically added elements
  function initializeAll() {
    document.querySelectorAll('.ice_cube_select').forEach(el => {
      IceCubeSelect.getOrCreate(el);
    });
  }

  // Initialize on DOMContentLoaded
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeAll);
  } else {
    initializeAll();
  }

  // Also handle Turbo/Turbolinks page changes
  document.addEventListener('turbo:load', initializeAll);
  document.addEventListener('turbolinks:load', initializeAll);

  // Expose globally
  window.IceCubeSelect = IceCubeSelect;
})();
