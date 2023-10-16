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
    ).first_or_create
  end
end