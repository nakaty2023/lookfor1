class Conversation < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  has_many :messages, dependent: :destroy
  validates :sender_id, uniqueness: { scope: :recipient_id }

  def self.between(sender_id, recipient_id)
    where(
      '(conversations.sender_id = ? AND conversations.recipient_id = ?) OR ' \
      '(conversations.sender_id = ? AND conversations.recipient_id = ?)',
      sender_id, recipient_id, recipient_id, sender_id
    ).first_or_create(sender_id:, recipient_id:)
  end

  def recipient_user_id(current_user_id)
    if sender_id == current_user_id
      recipient_id
    else
      sender_id
    end
  end
end
