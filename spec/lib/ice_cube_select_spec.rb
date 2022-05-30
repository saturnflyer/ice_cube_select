require 'spec_helper'

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

  describe "#filter_params" do
    it "Monthly with day_of_week" do
      expect(IceCubeSelect.filter_params({
        :validations => { "day_of_week" => { "wednesday" => %w[1 3] } },
        :rule_type => "IceCube::MonthlyRule",
        :interval => 1
      })).to eq({
        :validations => { :day_of_week => { :wednesday => [1, 3] } },
        :rule_type => "IceCube::MonthlyRule",
        :interval => 1
      })

      expect(IceCubeSelect.filter_params({
        :validations => { "day_of_week" => { "2" => %w[1 3] } },
        :rule_type => "IceCube::MonthlyRule",
        :interval => 1
      })).to eq({
        :validations => { :day_of_week => { 2 => [1, 3] } },
        :rule_type => "IceCube::MonthlyRule",
        :interval => 1
      })
    end
  end

end
