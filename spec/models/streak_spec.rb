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

require 'rails_helper'

RSpec.describe Streak, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
