require "ice_cube"

module IceCube
  # A monthly recurrence whose occurrences are fixed day-offsets from the
  # Nth <weekday> of each month. Unlike IceCube's ordinal monthly rules,
  # which count each weekday from day 1 of the month, this counts from a
  # single anchor date, so a pattern like "Sun/Tue/Thu and the following
  # Sun, starting after the 1st Saturday" lands on the same relative days
  # every month.
  class AnchoredMonthlyRule < Rule
    attr_reader :anchor_weekday, :anchor_ordinal, :day_offsets

    def initialize(anchor_weekday:, anchor_ordinal:, day_offsets:, interval: 1)
      @anchor_weekday = anchor_weekday.to_i
      @anchor_ordinal = anchor_ordinal.to_i
      @day_offsets = Array(day_offsets).map(&:to_i).sort
      @interval = interval.to_i
      @until_time = nil
    end

    attr_reader :interval, :until_time

    def until(time)
      @until_time = time
      self
    end

    # Counts are not supported for this rule (YAGNI); never force a
    # full-history walk.
    def full_required?
      false
    end

    def occurrence_count
      nil
    end

    # This rule uses no IceCube validations; return an empty set so callers
    # that introspect validations (e.g. selected_days) stay safe.
    def validations
      {}
    end

    # IceCube enumeration contract: the earliest occurrence at or after
    # `time` (and at or after the schedule's `start_time`), or nil when the
    # rule has terminated. Computed arithmetically rather than through the
    # monthly interval spinner.
    def next_time(time, start_time, closing_time)
      from = (time < start_time) ? start_time : time
      month = Date.new(from.year, from.month, 1)
      # A match always exists within a couple of months; 24 is a safe bound.
      24.times do
        occurrence_dates(month).each do |date|
          occ = at_wall_clock(start_time, date)
          next if occ < from || occ < start_time
          return nil if @until_time && occ > @until_time
          return occ
        end
        month = month.next_month
      end
      nil
    end

    def to_hash
      hash = {
        rule_type: self.class.name,
        interval: @interval,
        anchor_weekday: @anchor_weekday,
        anchor_ordinal: @anchor_ordinal,
        day_offsets: @day_offsets
      }
      hash[:until] = TimeUtil.serialize_time(@until_time) if @until_time
      hash
    end

    def self.from_hash(original_hash)
      hash = IceCube::FlexibleHash.new(original_hash)
      rule = new(
        anchor_weekday: hash[:anchor_weekday],
        anchor_ordinal: hash[:anchor_ordinal],
        day_offsets: hash[:day_offsets],
        interval: hash[:interval] || 1
      )
      rule.until(TimeUtil.deserialize_time(hash[:until])) if hash[:until]
      rule
    end

    def to_s
      "Monthly, after the #{ordinalize(@anchor_ordinal)} #{Date::DAYNAMES[@anchor_weekday]}: " \
        "day offsets #{@day_offsets.join(", ")}"
    end

    private

    # The occurrence dates for `month` (a Date on the 1st): each day-offset
    # added to the anchor. Empty when the month lacks the requested ordinal
    # weekday (e.g. no 5th Saturday).
    def occurrence_dates(month)
      first = month
      first += 1 until first.wday == @anchor_weekday
      anchor = first + (@anchor_ordinal - 1) * 7
      return [] unless anchor.month == month.month
      @day_offsets.map { |offset| anchor + offset }
    end

    # The occurrence instant on `date`: the schedule start's wall clock,
    # re-derived in its zone for that date (DST-correct).
    def at_wall_clock(start_time, date)
      start_time.change(year: date.year, month: date.month, day: date.day)
    end

    def ordinalize(n)
      %w[0th 1st 2nd 3rd 4th 5th][n] || "#{n}th"
    end
  end
end

# ice_cube's Rule.from_hash only understands its seven built-in interval
# types and rejects any other rule_type. Intercept our rule_type before
# that check and dispatch to AnchoredMonthlyRule; defer everything else to
# the original implementation.
module IceCube
  class Rule
    class << self
      alias_method :from_hash_without_anchored, :from_hash

      def from_hash(original_hash)
        hash = IceCube::FlexibleHash.new(original_hash)
        if hash[:rule_type].to_s == "IceCube::AnchoredMonthlyRule"
          IceCube::AnchoredMonthlyRule.from_hash(original_hash)
        else
          from_hash_without_anchored(original_hash)
        end
      end
    end
  end
end
