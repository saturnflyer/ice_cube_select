require "spec_helper"

describe IceCube::AnchoredMonthlyRule do
  let(:zone) { ActiveSupport::TimeZone["Eastern Time (US & Canada)"] }

  def schedule_for(start)
    sched = IceCube::Schedule.new(start)
    sched.add_recurrence_rule(
      described_class.new(anchor_weekday: 6, anchor_ordinal: 1, day_offsets: [1, 3, 5, 8])
    )
    sched
  end

  it "places sessions at first-Saturday + [1,3,5,8] for July and August 2026" do
    sched = schedule_for(zone.local(2026, 7, 5, 18, 30))
    got = sched.occurrences_between(zone.local(2026, 7, 1), zone.local(2026, 8, 31, 23, 59))
    expect(got.map { |o| o.strftime("%Y-%m-%d %H:%M") }).to eq [
      "2026-07-05 18:30", "2026-07-07 18:30", "2026-07-09 18:30", "2026-07-12 18:30",
      "2026-08-02 18:30", "2026-08-04 18:30", "2026-08-06 18:30", "2026-08-09 18:30"
    ]
  end

  it "produces the correct four dates for each month Jul-Dec 2026" do
    sched = schedule_for(zone.local(2026, 7, 5, 18, 30))
    got = sched.occurrences_between(zone.local(2026, 7, 1), zone.local(2026, 12, 31, 23, 59))
    expect(got.map { |o| o.strftime("%m/%d") }).to eq %w[
      07/05 07/07 07/09 07/12 08/02 08/04 08/06 08/09
      09/06 09/08 09/10 09/13 10/04 10/06 10/08 10/11
      11/08 11/10 11/12 11/15 12/06 12/08 12/10 12/13
    ]
  end

  it "keeps wall-clock time across the fall DST boundary" do
    # US Eastern falls back Nov 1, 2026; Nov occurrences are after it.
    sched = schedule_for(zone.local(2026, 7, 5, 18, 30))
    nov = sched.occurrences_between(zone.local(2026, 11, 1), zone.local(2026, 11, 30, 23, 59))
    expect(nov.map { |o| o.strftime("%m/%d %H:%M %Z") }.first).to eq "11/08 18:30 EST"
  end

  it "stops at until_time" do
    rule = described_class.new(anchor_weekday: 6, anchor_ordinal: 1, day_offsets: [1, 3, 5, 8])
    rule.until(zone.local(2026, 7, 9, 23, 59))
    sched = IceCube::Schedule.new(zone.local(2026, 7, 5, 18, 30))
    sched.add_recurrence_rule(rule)
    got = sched.occurrences_between(zone.local(2026, 7, 1), zone.local(2026, 8, 31, 23, 59))
    expect(got.map { |o| o.strftime("%m/%d") }).to eq %w[07/05 07/07 07/09]
  end

  it "round-trips through to_hash/from_hash" do
    rule = described_class.new(anchor_weekday: 6, anchor_ordinal: 1, day_offsets: [1, 3, 5, 8])
    rebuilt = described_class.from_hash(rule.to_hash)
    expect(rebuilt.to_hash).to eq rule.to_hash
  end

  it "coerces string params from the form hash" do
    rule = described_class.from_hash(
      "rule_type" => "IceCube::AnchoredMonthlyRule", "interval" => "1",
      "anchor_weekday" => "6", "anchor_ordinal" => "1", "day_offsets" => %w[1 3 5 8]
    )
    expect(rule.to_hash).to eq(
      rule_type: "IceCube::AnchoredMonthlyRule", interval: 1,
      anchor_weekday: 6, anchor_ordinal: 1, day_offsets: [1, 3, 5, 8]
    )
  end

  it "survives a YAML round-trip (as the app stores it)" do
    rule = described_class.new(anchor_weekday: 6, anchor_ordinal: 1, day_offsets: [1, 3, 5, 8])
    yaml = rule.to_hash.to_yaml
    loaded = YAML.safe_load(yaml, permitted_classes: [Symbol, Time, Date])
    expect(described_class.from_hash(loaded).to_hash).to eq rule.to_hash
  end
end
