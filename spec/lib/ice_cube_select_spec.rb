require "spec_helper"

describe IceCubeSelect do
  it "should be a module" do
    expect(IceCubeSelect).to be_kind_of Module
  end

  describe "#is_valid_rule?" do
    it "should identify invalid rules" do
      expect(IceCubeSelect.is_valid_rule?(nil)).to be false
      expect(IceCubeSelect.is_valid_rule?("")).to be false
      expect(IceCubeSelect.is_valid_rule?(false)).to be false
      expect(IceCubeSelect.is_valid_rule?("null")).to be false
      expect(IceCubeSelect.is_valid_rule?("0")).to be false
      expect(IceCubeSelect.is_valid_rule?("custom")).to be false
      expect(IceCubeSelect.is_valid_rule?([1, 2])).to be false
    end

    it "should identify valid rules" do
      expect(IceCubeSelect.is_valid_rule?(IceCube::Rule.weekly)).to be true
      expect(IceCubeSelect.is_valid_rule?(IceCube::Rule.weekly.to_hash)).to be true
      expect(IceCubeSelect.is_valid_rule?(IceCube::Rule.weekly.to_hash.to_json)).to be true
    end
  end

  describe "anchored monthly rule" do
    let(:anchored_hash) do
      {"rule_type" => "IceCube::AnchoredMonthlyRule", "interval" => 1,
       "anchor_weekday" => 6, "anchor_ordinal" => 1, "day_offsets" => [1, 3, 5, 8]}
    end

    it "dispatches Rule.from_hash to AnchoredMonthlyRule" do
      rule = IceCube::Rule.from_hash(anchored_hash)
      expect(rule).to be_a(IceCube::AnchoredMonthlyRule)
      expect(rule.day_offsets).to eq [1, 3, 5, 8]
    end

    it "still builds built-in rules" do
      expect(IceCube::Rule.from_hash(IceCube::Rule.weekly.to_hash)).to be_a(IceCube::WeeklyRule)
    end

    it "builds the anchored rule through dirty_hash_to_rule (JSON form payload)" do
      rule = IceCubeSelect.dirty_hash_to_rule(anchored_hash.to_json)
      expect(rule).to be_a(IceCube::AnchoredMonthlyRule)
      expect(rule.anchor_weekday).to eq 6
      expect(rule.anchor_ordinal).to eq 1
      expect(rule.day_offsets).to eq [1, 3, 5, 8]
    end
  end

  describe "#filter_params" do
    it "Monthly with day_of_week" do
      expect(IceCubeSelect.send(:filter_params, {
        validations: {"day_of_week" => {"wednesday" => %w[1 3]}},
        rule_type: "IceCube::MonthlyRule",
        interval: 1
      })).to eq({
        validations: {day_of_week: {wednesday: [1, 3]}},
        rule_type: "IceCube::MonthlyRule",
        interval: 1
      })

      expect(IceCubeSelect.send(:filter_params, {
        validations: {"day_of_week" => {"2" => %w[1 3]}},
        rule_type: "IceCube::MonthlyRule",
        interval: 1
      })).to eq({
        validations: {day_of_week: {2 => [1, 3]}},
        rule_type: "IceCube::MonthlyRule",
        interval: 1
      })
    end
  end
end
