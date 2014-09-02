# == Schema Information
#
# Table name: streaks
#
#  id             :integer          not null, primary key
#  username       :string(255)      not null
#  created_at     :datetime
#  updated_at     :datetime
#  longest_streak :integer
#  current_streak :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :streak do
  end
end
