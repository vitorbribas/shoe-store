# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Model, type: :model do
  subject(:model) { build(:model) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'relationships' do
    it { should have_many(:inventories) }
    it { should have_many(:stores).through(:inventories) }
  end
end
