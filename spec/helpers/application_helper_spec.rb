require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helperi do

  describe "standard_datetime" do
    it "properly fomats a valid date" do
      expect(standard_datetime(Time.new(2013,2,1))).to eq 'Feb 1, 2013 at 00:00'
    end

    it 'returns blank for a null date' do
      expect(standard_datetime(nil)).to be_nil
    end
  end

  describe "short_date" do
    it "hides the year when year is current" do
      d = Date.new(Time.zone.now.year, 11, 1)
      expect(short_date(d)).to eq "Nov 1"
    end

    it 'shows the year when year is not current' do
      d = Date.new(Time.zone.now.year + 1, 6, 30)
      expect(short_date(d)).to eq "Jun 30, #{Time.zone.now.year + 1}"
    end
  end

end
