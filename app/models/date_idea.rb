# == Schema Information
#
# Table name: date_ideas
#
#  id          :bigint           not null, primary key
#  budget      :decimal(8, 2)
#  city        :string
#  description :text
#  effort      :string
#  latitude    :decimal(10, 6)
#  longitude   :decimal(10, 6)
#  setting     :string
#  time_of_day :string
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class DateIdea < ApplicationRecord
validates :title, presence: true
  
  has_many :saved_dates, dependent: :destroy
  has_many :users, through: :saved_dates
  
  # Scopes for filtering
  scope :by_budget, ->(max_budget) { where('budget <= ?', max_budget) if max_budget.present? }
  scope :by_time_of_day, ->(time) { where(time_of_day: time) if time.present? }
  scope :by_setting, ->(setting) { where(setting: setting) if setting.present? }
  scope :by_effort, ->(effort) { where(effort: effort) if effort.present? }
  scope :by_city, ->(city) { where(city: city) if city.present? }
end
