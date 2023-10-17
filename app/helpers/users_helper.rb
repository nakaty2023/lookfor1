module UsersHelper
  def gender_options
    User.genders.map { |key, value| [key.capitalize, value] }
  end

  def conversation_with(user)
    Conversation.between(user.id, current_user.id)
  end
end
