class Sample
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :no_defaults_not_set, :with_defaults_not_set
  attr_writer :no_defaults_with_custom,
    :with_defaults_and_set,
    :with_defaults_and_custom,
    :non_recurring_with_defaults

  def no_defaults_with_custom
    @no_defaults_with_custom || IceCube::Rule.daily(2).to_hash
  end

  def with_defaults_and_set
    @with_defaults_and_set || IceCube::Rule.monthly.day_of_month(-1).to_hash
  end

  def with_defaults_and_custom
    @with_defaults_and_custom || IceCube::Rule.daily(2).to_hash
  end

  def non_recurring_with_defaults
    @non_recurring_with_defaults || 1
  end

  def persisted?
    false
  end
end
