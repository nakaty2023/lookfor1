class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.enum_options_for_select(attr_name)
    send(attr_name.to_s.pluralize).to_h { |k, _| [human_attribute_enum_value(attr_name, k), k] }
  end
end
