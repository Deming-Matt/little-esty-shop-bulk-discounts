require 'rails_helper'

RSpec.describe 'merchants dashboard' do
  it 'shows the name of the merchant' do
    merch1 = Merchant.create!(name: 'Floopy Fopperations')

    visit "/merchant/#{merchant.id}/dashboard"

    expect(page).to have_content(merch1.name)
  end
end
