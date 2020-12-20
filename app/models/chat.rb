class Chat < ApplicationRecord

    validates :from_user_id, presence: true
    validates :to_user_id, presence: true
    validates :text, presence: true
    # validates :read. presence: true
end
