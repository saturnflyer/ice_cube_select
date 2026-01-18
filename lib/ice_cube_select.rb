require "ice_cube_select/engine"
require "ice_cube"

module IceCubeSelect

  def self.dirty_hash_to_rule(params)
    return params if params.is_a? IceCube::Rule

    params = JSON.parse(params, quirks_mode: true) if params.is_a?(String)
    return nil if params.nil?

    params = params.symbolize_keys
    rules_hash = filter_params(params)
    IceCube::Rule.from_hash(rules_hash)
  end

  def self.is_valid_rule?(possible_rule)
    return true if possible_rule.is_a?(IceCube::Rule)
    return false if possible_rule.blank?

    if possible_rule.is_a?(String)
      possible_rule = JSON.parse(possible_rule)
    end

    # TODO: this should really have an extra step where it tries to perform the final parsing
    possible_rule.is_a?(Hash)
  rescue JSON::ParserError
    false
  end

  private

  def self.filter_params(params)
    params.reject! { |key, value| value.blank? || value == "null" }

    params[:interval] = params[:interval].to_i if params[:interval]
    params[:week_start] = params[:week_start].to_i if params[:week_start]

    params[:validations] ||= {}
    params[:validations] = deep_symbolize_keys(params[:validations])

    if params[:validations][:day]
      params[:validations][:day] = to_int_array(params[:validations][:day])
    end

    if params[:validations][:day_of_month]
      params[:validations][:day_of_month] = to_int_array(params[:validations][:day_of_month])
    end

    if params[:validations][:day_of_week]
      dow = params[:validations][:day_of_week]
      params[:validations][:day_of_week] = {}
      dow.each do |key, value|
        # Keep symbolic keys as symbols, convert numeric strings to integers
        key_str = key.to_s
        new_key = key_str.match?(/^\d+$/) ? key_str.to_i : key.to_sym
        params[:validations][:day_of_week][new_key] = to_int_array(value)
      end
    end

    if params[:validations][:day_of_year]
      params[:validations][:day_of_year] = to_int_array(params[:validations][:day_of_year])
    end

    params
  end

  def self.to_int_array(value)
    return [] if value.nil?
    if value.is_a?(Hash)
      value.values.flatten.map(&:to_i)
    elsif value.is_a?(Array)
      value.flatten.map(&:to_i)
    else
      [value.to_i]
    end
  end

  def self.deep_symbolize_keys(hash)
    return hash unless hash.is_a?(Hash)
    hash.each_with_object({}) do |(key, value), result|
      new_key = key.respond_to?(:to_sym) ? key.to_sym : key
      result[new_key] = value.is_a?(Hash) ? deep_symbolize_keys(value) : value
    end
  end
end
