# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Model do
  subject(:model) { build(:model) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'relationships' do
    it { is_expected.to have_many(:inventories).dependent(:destroy) }
    it { is_expected.to have_many(:stores).through(:inventories) }
  end
end
