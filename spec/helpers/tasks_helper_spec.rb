require 'rails_helper'

RSpec.describe TasksHelper, type: :helper do

  describe "display_weight" do

    it "should be danger when 10" do
      expect(display_weight(10)).to eq "<span class=\"label label-danger\">10</span>"
    end

    it "should be warning when 5" do
      expect(display_weight(5)).to eq "<span class=\"label label-warning\">5</span>"
    end

    it "should be success when 2" do
      expect(display_weight(2)).to eq "<span class=\"label label-success\">2</span>"
    end

    it "should be primary when 1" do
      expect(display_weight(1)).to eq "<span class=\"label label-primary\">1</span>"
    end
  end

end
