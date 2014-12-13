require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do

  describe "standard_datetime" do

    it "properly fomats a valid date" do
      expect(standard_datetime(Time.new(2013,2,1))).to eq 'Feb 1, 2013 at 00:00'
    end

    it 'returns blank for a null date' do
      expect(standard_datetime(nil)).to be_nil
    end

  end

end
