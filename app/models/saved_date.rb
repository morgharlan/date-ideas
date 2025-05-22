# == Schema Information
#
# Table name: saved_dates
#
#  id           :bigint           not null, primary key
#  completed    :boolean          default(FALSE)
#  favorite     :boolean          default(FALSE)
#  note         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  date_idea_id :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_saved_dates_on_date_idea_id              (date_idea_id)
#  index_saved_dates_on_user_id                   (user_id)
#  index_saved_dates_on_user_id_and_date_idea_id  (user_id,date_idea_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (date_idea_id => date_ideas.id)
#  fk_rails_...  (user_id => users.id)
#
class SavedDate < ApplicationRecord
  belongs_to :user
  belongs_to :date_idea
  
  validates :user_id, uniqueness: { scope: :date_idea_id }
  
  scope :favorites, -> { where(favorite: true) }
  scope :completed, -> { where(completed: true) }
end
