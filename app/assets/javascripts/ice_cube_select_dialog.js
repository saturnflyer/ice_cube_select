// IceCubeSelectDialog - Vanilla JS implementation
// Replaces the jQuery version

(function() {
  'use strict';

  class IceCubeSelectDialog {
    constructor(iceCubeSelector) {
      this.iceCubeSelector = iceCubeSelector;
      this.iceCubeSelectInstance = IceCubeSelect.getOrCreate(iceCubeSelector);
      this.currentRule = this.iceCubeSelectInstance.currentRule();

      this.initDialogBox();

      if (!this.currentRule.hash || !this.currentRule.hash.rule_type) {
        this.freqChanged();
      } else {
        setTimeout(() => this.positionDialogVert(), 10);
      }
    }

    initDialogBox() {
      // Remove any existing dialog
      const existing = document.querySelector('.ice_cube_select_dialog_holder');
      if (existing) existing.remove();

      // Find container (body or jQuery Mobile active page)
      let openIn = document.body;
      const activePage = document.querySelector('.ui-page-active');
      if (activePage) openIn = activePage;

      // Insert template
      openIn.insertAdjacentHTML('beforeend', this.template());

      this.outerHolder = document.querySelector('.ice_cube_select_dialog_holder');
      this.innerHolder = this.outerHolder.querySelector('.ice_cube_select_dialog');
      this.content = this.outerHolder.querySelector('.ice_cube_select_dialog_content');

      this.positionDialogVert(true);
      this.mainEventInit();
      this.freqInit();
      this.summaryInit();

      this.outerHolder.dispatchEvent(new CustomEvent('ice_cube_select:dialog_opened'));
      this.freqSelect.focus();
    }

    ordinalSuffixOf(i) {
      const j = i % 10;
      const k = i % 100;
      if (j === 1 && k !== 11) return i + 'st';
      if (j === 2 && k !== 12) return i + 'nd';
      if (j === 3 && k !== 13) return i + 'rd';
      return i + 'th';
    }

    fullStringWeekday(num) {
      const weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
      return weekdays[num];
    }

    positionDialogVert(initialPositioning) {
      const windowHeight = window.innerHeight;
      let dialogHeight = this.content.offsetHeight;

      if (dialogHeight < 80) dialogHeight = 80;

      let marginTop = (windowHeight - dialogHeight) / 2 - 30;
      if (marginTop < 10) marginTop = 10;

      if (initialPositioning) {
        // Lock content width to prevent dialog from expanding on interactions
        this.content.style.width = this.content.offsetWidth + 'px';
        this.innerHolder.style.marginTop = marginTop + 'px';
        this.innerHolder.style.minHeight = dialogHeight + 'px';
        this.innerHolder.dispatchEvent(new CustomEvent('ice_cube_select:dialog_positioned'));
      } else {
        this.innerHolder.classList.add('animated');
        this.innerHolder.style.marginTop = marginTop + 'px';
        this.innerHolder.style.minHeight = dialogHeight + 'px';

        // Use CSS transition end instead of jQuery animate
        const onTransitionEnd = () => {
          this.innerHolder.classList.remove('animated');
          this.innerHolder.dispatchEvent(new CustomEvent('ice_cube_select:dialog_positioned'));
          this.innerHolder.removeEventListener('transitionend', onTransitionEnd);
        };

        this.innerHolder.addEventListener('transitionend', onTransitionEnd);

        // Fallback if no transition
        setTimeout(() => {
          if (this.innerHolder.classList.contains('animated')) {
            onTransitionEnd();
          }
        }, 250);
      }
    }

    cancel() {
      this.outerHolder.remove();
      this.iceCubeSelectInstance.cancel();
    }

    outerCancel(event) {
      if (event.target.classList.contains('ice_cube_select_dialog_holder')) {
        this.cancel();
      }
    }

    save() {
      if (!this.currentRule.str) return;
      this.outerHolder.remove();
      this.iceCubeSelectInstance.save(this.currentRule);
    }

    mainEventInit() {
      this.outerHolder.addEventListener('click', (e) => this.outerCancel(e));

      this.content.querySelector('h4 a').addEventListener('click', (e) => {
        e.preventDefault();
        this.cancel();
      });

      this.saveButton = this.content.querySelector('input.ice_cube_select_save');
      this.saveButton.addEventListener('click', () => this.save());

      this.content.querySelector('input.ice_cube_select_cancel').addEventListener('click', () => this.cancel());
    }

    freqInit() {
      this.freqSelect = this.outerHolder.querySelector('.ice_cube_select_frequency');

      if (this.currentRule.hash && this.currentRule.hash.rule_type) {
        const ruleType = this.currentRule.hash.rule_type;

        if (ruleType.includes('Weekly')) {
          this.freqSelect.selectedIndex = 1;
          this.initWeeklyOptions();
        } else if (ruleType.includes('Monthly')) {
          this.freqSelect.selectedIndex = 2;
          this.initMonthlyOptions();
        } else if (ruleType.includes('Yearly')) {
          this.freqSelect.selectedIndex = 3;
          this.initYearlyOptions();
        } else {
          this.initDailyOptions();
        }
      }

      this.freqSelect.addEventListener('change', () => this.freqChanged());
    }

    initDailyOptions() {
      const section = this.content.querySelector('.daily_options');
      const intervalInput = section.querySelector('.ice_cube_select_daily_interval');

      if (this.currentRule.hash && this.currentRule.hash.interval) {
        intervalInput.value = this.currentRule.hash.interval;
      }

      intervalInput.addEventListener('change', (e) => this.intervalChanged(e));
      intervalInput.addEventListener('keyup', (e) => this.intervalChanged(e));

      section.style.display = 'block';
    }

    initWeeklyOptions() {
      const section = this.content.querySelector('.weekly_options');
      const intervalInput = section.querySelector('.ice_cube_select_weekly_interval');

      if (this.currentRule.hash && this.currentRule.hash.interval) {
        intervalInput.value = this.currentRule.hash.interval;
      }

      intervalInput.addEventListener('change', (e) => this.intervalChanged(e));
      intervalInput.addEventListener('keyup', (e) => this.intervalChanged(e));

      // Reset all day selections
      section.querySelectorAll('.day_holder a').forEach(el => el.classList.remove('selected'));

      // Apply current selections
      if (this.currentRule.hash?.validations?.day) {
        this.currentRule.hash.validations.day.forEach(val => {
          const dayLink = section.querySelector(`.day_holder a[data-value="${val}"]`);
          if (dayLink) dayLink.classList.add('selected');
        });
      }

      section.querySelector('.day_holder').addEventListener('click', (e) => {
        if (e.target.tagName === 'A') {
          this.daysChanged(e);
        }
      });

      section.style.display = 'block';
    }

    initMonthlyOptions() {
      const section = this.content.querySelector('.monthly_options');
      const intervalInput = section.querySelector('.ice_cube_select_monthly_interval');

      if (this.currentRule.hash && this.currentRule.hash.interval) {
        intervalInput.value = this.currentRule.hash.interval;
      }

      intervalInput.addEventListener('change', (e) => this.intervalChanged(e));
      intervalInput.addEventListener('keyup', (e) => this.intervalChanged(e));

      // Ensure validations exist
      this.currentRule.hash = this.currentRule.hash || {};
      this.currentRule.hash.validations = this.currentRule.hash.validations || {};
      this.currentRule.hash.validations.day_of_month = this.currentRule.hash.validations.day_of_month || [];
      this.currentRule.hash.validations.day_of_week = this.currentRule.hash.validations.day_of_week || {};

      this.initCalendarDays(section);
      this.initCalendarWeeks(section);

      const inWeekMode = Object.keys(this.currentRule.hash.validations.day_of_week).length > 0;

      section.querySelector('.monthly_rule_type_week').checked = inWeekMode;
      section.querySelector('.monthly_rule_type_day').checked = !inWeekMode;

      this.toggleMonthView();

      section.querySelectorAll('input[name=monthly_rule_type]').forEach(input => {
        input.addEventListener('change', () => this.toggleMonthView());
      });

      section.style.display = 'block';
    }

    initYearlyOptions() {
      const section = this.content.querySelector('.yearly_options');
      const intervalInput = section.querySelector('.ice_cube_select_yearly_interval');

      if (this.currentRule.hash && this.currentRule.hash.interval) {
        intervalInput.value = this.currentRule.hash.interval;
      }

      intervalInput.addEventListener('change', (e) => this.intervalChanged(e));
      intervalInput.addEventListener('keyup', (e) => this.intervalChanged(e));

      section.style.display = 'block';
    }

    summaryInit() {
      this.summary = this.outerHolder.querySelector('.ice_cube_select_summary');
      this.summaryUpdate();
    }

    summaryUpdate() {
      if (this.currentRule.hash && this.currentRule.str) {
        this.summary.classList.remove('fetching');
        this.saveButton.classList.remove('disabled');

        let ruleStr = this.currentRule.str.replace('*', '');
        if (ruleStr.length < 20) {
          ruleStr = IceCubeSelect.texts.summary + ': ' + ruleStr;
        }
        this.summary.querySelector('span').innerHTML = ruleStr;
      } else {
        this.summary.classList.add('fetching');
        this.saveButton.classList.add('disabled');
        this.summary.querySelector('span').innerHTML = '';
        this.summaryFetch();
      }
    }

    summaryFetch() {
      if (!this.currentRule.hash || !this.currentRule.hash.rule_type) return;

      this.currentRule.hash.week_start = IceCubeSelect.texts.first_day_of_week;

      // Get translate URL from data attribute on the select element
      const translateUrl = this.iceCubeSelector.dataset.translateUrl || '/ice_cube_select/translate';
      const locale = IceCubeSelect.texts.locale_iso_code;

      // Build form data
      const formData = new FormData();
      this.buildFormData(formData, this.currentRule.hash);

      fetch(`${translateUrl}/${locale}`, {
        method: 'POST',
        body: formData,
        headers: {
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
        .then(response => response.text())
        .then(data => this.summaryFetchSuccess(data))
        .catch(error => console.error('Summary fetch error:', error));
    }

    buildFormData(formData, data, parentKey = '') {
      if (data && typeof data === 'object' && !(data instanceof Date) && !(data instanceof File)) {
        Object.keys(data).forEach(key => {
          this.buildFormData(formData, data[key], parentKey ? `${parentKey}[${key}]` : key);
        });
      } else if (data !== null && data !== undefined) {
        formData.append(parentKey, data);
      }
    }

    summaryFetchSuccess(data) {
      this.currentRule.str = data;
      this.summaryUpdate();
    }

    initCalendarDays(section) {
      const monthlyCalendar = section.querySelector('.ice_cube_select_calendar_day');
      monthlyCalendar.innerHTML = '';

      for (let num = 1; num <= 31; num++) {
        const dayLink = document.createElement('a');
        dayLink.href = '';
        dayLink.textContent = num;
        dayLink.classList.add('a_day');
        dayLink.setAttribute('aria-label', this.ordinalSuffixOf(num) + ' Day of Month');

        if (this.currentRule.hash.validations.day_of_month.includes(num)) {
          dayLink.classList.add('selected');
        }

        monthlyCalendar.appendChild(dayLink);
      }

      // Add "Last Day" option
      const endOfMonthLink = document.createElement('a');
      endOfMonthLink.href = '';
      endOfMonthLink.textContent = IceCubeSelect.texts.last_day;
      endOfMonthLink.classList.add('end_of_month');
      endOfMonthLink.setAttribute('aria-label', 'Last Day of Month');

      if (this.currentRule.hash.validations.day_of_month.includes(-1)) {
        endOfMonthLink.classList.add('selected');
      }

      monthlyCalendar.appendChild(endOfMonthLink);

      monthlyCalendar.addEventListener('click', (e) => {
        if (e.target.tagName === 'A') {
          e.preventDefault();
          this.dateOfMonthChanged(e);
        }
      });
    }

    initCalendarWeeks(section) {
      const monthlyCalendar = section.querySelector('.ice_cube_select_calendar_week');
      monthlyCalendar.innerHTML = '';

      const rowLabels = IceCubeSelect.texts.order;
      const showRow = IceCubeSelect.options.monthly.show_week;
      const cellStr = IceCubeSelect.texts.days_first_letter;
      const weekNums = [1, 2, 3, 4, 5, -1];

      weekNums.forEach((num, index) => {
        if (showRow[index]) {
          const span = document.createElement('span');
          span.textContent = rowLabels[num === -1 ? 5 : num - 1];
          monthlyCalendar.appendChild(span);

          const firstDay = IceCubeSelect.texts.first_day_of_week;
          for (let d = firstDay; d < firstDay + 7; d++) {
            const dayOfWeek = d % 7;
            const dayLink = document.createElement('a');
            dayLink.href = '';
            dayLink.textContent = cellStr[dayOfWeek];
            dayLink.setAttribute('aria-label', this.ordinalSuffixOf(num === -1 ? 'Last' : num) + ' ' + this.fullStringWeekday(dayOfWeek));
            dayLink.setAttribute('day', dayOfWeek);
            dayLink.setAttribute('instance', num);
            monthlyCalendar.appendChild(dayLink);
          }
        }
      });

      // Apply current selections
      const dayOfWeek = this.currentRule.hash.validations.day_of_week;
      Object.keys(dayOfWeek).forEach(key => {
        dayOfWeek[key].forEach(instance => {
          const link = section.querySelector(`a[day="${key}"][instance="${instance}"]`);
          if (link) link.classList.add('selected');
        });
      });

      monthlyCalendar.addEventListener('click', (e) => {
        if (e.target.tagName === 'A') {
          e.preventDefault();
          this.weekOfMonthChanged(e);
        }
      });
    }

    toggleMonthView() {
      const weekMode = this.content.querySelector('.monthly_rule_type_week').checked;
      this.content.querySelector('.ice_cube_select_calendar_week').style.display = weekMode ? 'block' : 'none';
      this.content.querySelector('.ice_cube_select_calendar_day').style.display = weekMode ? 'none' : 'block';
    }

    freqChanged() {
      if (typeof this.currentRule.hash !== 'object' || this.currentRule.hash === null) {
        this.currentRule.hash = {};
      }

      this.currentRule.hash.interval = 1;
      this.currentRule.hash.until = null;
      this.currentRule.hash.count = null;
      this.currentRule.hash.validations = null;

      this.content.querySelectorAll('.freq_option_section').forEach(el => {
        el.style.display = 'none';
      });

      this.content.querySelectorAll('input[type=radio], input[type=checkbox]').forEach(el => {
        el.checked = false;
      });

      switch (this.freqSelect.value) {
        case 'Weekly':
          this.currentRule.hash.rule_type = 'IceCube::WeeklyRule';
          this.currentRule.str = IceCubeSelect.texts.weekly;
          this.initWeeklyOptions();
          break;
        case 'Monthly':
          this.currentRule.hash.rule_type = 'IceCube::MonthlyRule';
          this.currentRule.str = IceCubeSelect.texts.monthly;
          this.initMonthlyOptions();
          break;
        case 'Yearly':
          this.currentRule.hash.rule_type = 'IceCube::YearlyRule';
          this.currentRule.str = IceCubeSelect.texts.yearly;
          this.initYearlyOptions();
          break;
        default:
          this.currentRule.hash.rule_type = 'IceCube::DailyRule';
          this.currentRule.str = IceCubeSelect.texts.daily;
          this.initDailyOptions();
      }

      this.summaryUpdate();
      this.positionDialogVert();
    }

    intervalChanged(event) {
      this.currentRule.str = null;
      this.currentRule.hash = this.currentRule.hash || {};

      let interval = parseInt(event.target.value, 10);
      if (interval < 1 || isNaN(interval)) {
        interval = 1;
      }
      this.currentRule.hash.interval = interval;
      this.summaryUpdate();
    }

    daysChanged(event) {
      event.preventDefault();
      event.target.classList.toggle('selected');

      this.currentRule.str = null;
      this.currentRule.hash = this.currentRule.hash || {};
      this.currentRule.hash.validations = {};

      const selectedDays = this.content.querySelectorAll('.day_holder a.selected');
      this.currentRule.hash.validations.day = Array.from(selectedDays).map(el => {
        return parseInt(el.dataset.value, 10);
      });

      this.summaryUpdate();
    }

    dateOfMonthChanged(event) {
      event.target.classList.toggle('selected');

      this.currentRule.str = null;
      this.currentRule.hash = this.currentRule.hash || {};
      this.currentRule.hash.validations = {};

      const selectedDays = this.content.querySelectorAll('.monthly_options .ice_cube_select_calendar_day a.selected');
      this.currentRule.hash.validations.day_of_week = {};
      this.currentRule.hash.validations.day_of_month = Array.from(selectedDays).map(el => {
        return el.textContent === IceCubeSelect.texts.last_day ? -1 : parseInt(el.textContent, 10);
      });

      this.summaryUpdate();
    }

    weekOfMonthChanged(event) {
      event.target.classList.toggle('selected');

      this.currentRule.str = null;
      this.currentRule.hash = this.currentRule.hash || {};
      this.currentRule.hash.validations = {};
      this.currentRule.hash.validations.day_of_month = [];
      this.currentRule.hash.validations.day_of_week = {};

      const selectedLinks = this.content.querySelectorAll('.monthly_options .ice_cube_select_calendar_week a.selected');
      selectedLinks.forEach(elm => {
        const day = parseInt(elm.getAttribute('day'), 10);
        const instance = parseInt(elm.getAttribute('instance'), 10);

        if (!this.currentRule.hash.validations.day_of_week[day]) {
          this.currentRule.hash.validations.day_of_week[day] = [];
        }
        this.currentRule.hash.validations.day_of_week[day].push(instance);
      });

      this.summaryUpdate();
    }

    template() {
      const texts = IceCubeSelect.texts;
      const firstDay = texts.first_day_of_week;

      let dayButtons = '';
      for (let d = firstDay; d < firstDay + 7; d++) {
        const dayOfWeek = d % 7;
        const fullDayName = this.fullStringWeekday(dayOfWeek);
        dayButtons += `<a href="#" data-value="${dayOfWeek}" aria-label="${fullDayName}">${texts.days_first_letter[dayOfWeek]}</a>`;
      }

      return `
        <div id="ice_cube_select_modal" class="ice_cube_select_dialog_holder">
          <div class="ice_cube_select_dialog">
            <div class="ice_cube_select_dialog_content">
              <h4>${texts.repeat}
                <a href="#" id="ice_cube_select_cancel_button" title="${texts.cancel}" alt="${texts.cancel}"></a>
              </h4>

              <p class="frequency-select-wrapper">
                <label for="ice_cube_select_frequency">${texts.frequency}:</label>
                <select data-wrapper-class="ui-recurring-select" id="ice_cube_select_frequency" class="ice_cube_select_frequency" name="ice_cube_select_frequency">
                  <option value="Daily">${texts.daily}</option>
                  <option value="Weekly">${texts.weekly}</option>
                  <option value="Monthly">${texts.monthly}</option>
                  <option value="Yearly">${texts.yearly}</option>
                </select>
              </p>

              <div class="daily_options freq_option_section">
                <p>
                  ${texts.every}
                  <input type="text" data-wrapper-class="ui-recurring-select" name="ice_cube_select_daily_interval" class="ice_cube_select_daily_interval ice_cube_select_interval" value="1" size="2" title="Enter number of days to repeat" />
                  ${texts.days}
                </p>
              </div>

              <div class="weekly_options freq_option_section">
                <p>
                  ${texts.every}
                  <input type="text" data-wrapper-class="ui-recurring-select" name="ice_cube_select_weekly_interval" class="ice_cube_select_weekly_interval ice_cube_select_interval" value="1" size="2" title="Enter number of weeks to repeat" />
                  ${texts.weeks_on}:
                </p>
                <div class="day_holder">${dayButtons}</div>
                <span style="clear:both; visibility:hidden; height:1px;">.</span>
              </div>

              <div class="monthly_options freq_option_section">
                <p>
                  ${texts.every}
                  <input type="text" data-wrapper-class="ui-recurring-select" name="ice_cube_select_monthly_interval" class="ice_cube_select_monthly_interval ice_cube_select_interval" value="1" size="2" title="Enter number of months to repeat" />
                  ${texts.months}:
                </p>
                <p class="monthly_rule_type">
                  <span>
                    <label for="monthly_rule_type_day">${texts.day_of_month}</label>
                    <input type="radio" class="monthly_rule_type_day" name="monthly_rule_type" id="monthly_rule_type_day" value="true" />
                  </span>
                  <span>
                    <label for="monthly_rule_type_week">${texts.day_of_week}</label>
                    <input type="radio" class="monthly_rule_type_week" name="monthly_rule_type" id="monthly_rule_type_week" value="true" />
                  </span>
                </p>
                <p class="ice_cube_select_calendar_day"></p>
                <p class="ice_cube_select_calendar_week"></p>
              </div>

              <div class="yearly_options freq_option_section">
                <p>
                  ${texts.every}
                  <input type="text" data-wrapper-class="ui-recurring-select" name="ice_cube_select_yearly_interval" class="ice_cube_select_yearly_interval ice_cube_select_interval" value="1" size="2" title="Enter number of years to repeat" />
                  ${texts.years}
                </p>
              </div>

              <p class="ice_cube_select_summary">
                <span></span>
              </p>

              <div class="controls">
                <input type="button" data-wrapper-class="ui-recurring-select" id="ice_cube_select_save" class="ice_cube_select_save" value="${texts.ok}" />
                <input type="button" data-wrapper-class="ui-recurring-select" id="ice_cube_select_cancel" class="ice_cube_select_cancel" value="${texts.cancel}" />
              </div>
            </div>
          </div>
        </div>
      `;
    }
  }

  // Expose globally
  window.IceCubeSelectDialog = IceCubeSelectDialog;
})();
