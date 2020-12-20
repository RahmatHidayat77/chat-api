class Chat < ApplicationRecord

    validates :from_user_id, presence: true, uniqueness: true
    validates :to_user_id, presence: true, uniqueness: true
    validates :text, presence: true
    # validates :read. presence: true
end
