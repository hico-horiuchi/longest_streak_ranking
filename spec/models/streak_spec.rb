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

require 'rails_helper'

RSpec.describe Streak, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
