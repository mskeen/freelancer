require 'rails_helper'

RSpec.describe AppConfig, :type => :model do

  describe AppConfig do
    it 'returns valid entries if they exist' do
      expect(AppConfig.use_analytics).to be 0
    end

    it 'returns nil for invalid entry' do
      expect(AppConfig.use_analytics_x).to be_nil
    end

  end
end
