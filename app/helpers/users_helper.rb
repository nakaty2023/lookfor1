module UsersHelper
  def gender_options
    User.genders.map { |key, value| [key.capitalize, value] }
  end
end
