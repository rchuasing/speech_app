# frozen_string_literal: true

Date::DATE_FORMATS[:default] = '%m/%d/%Y'

module FixDateFormatting
  class EasyDate < ActiveRecord::Type::Date
    def cast_value(value)
      default = super
      parsed = Chronic.parse(value)&.to_date if value.is_a?(String)
      parsed || default
    end
  end

  def inherited(subclass)
    super
    if database_exists? && subclass.table_exists?
      date_attributes = subclass.attribute_types.select { |_, type| type.is_a?(ActiveRecord::Type::Date) }
      date_attributes.each do |name, _type|
        subclass.attribute name, EasyDate.new
      end
    end
  end

  def database_exists?
    ActiveRecord::Base.connection
  rescue ActiveRecord::NoDatabaseError
    false
  else
    true
  end
end

Rails.application.config.to_prepare do
  ApplicationRecord.extend(FixDateFormatting)
end
