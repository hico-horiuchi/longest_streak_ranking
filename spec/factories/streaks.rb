# == Schema Information
#
# Table name: streaks
#
#  id             :integer          not null, primary key
#  username       :string(255)      not null
#  longest_streak :integer          not null
#  created_at     :datetime
#  updated_at     :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :streak do
  end
end
