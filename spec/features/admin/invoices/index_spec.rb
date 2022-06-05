require 'rails_helper'

RSpec.describe "Admin Invoice Index" do
    before :each do
      @merch1 = Merchant.create!(name: 'Floopy Fopperations')
      @item1 = @merch1.items.create!(name: 'Floopy Original', description: 'the best', unit_price: 450)
      @item2 = @merch1.items.create!(name: 'Floopy Updated', description: 'the better', unit_price: 950)
      @item3 = @merch1.items.create!(name: 'Floopy Retro', description: 'the OG', unit_price: 550)

      @merch2 = Merchant.create!(name: 'Goopy Gopperations')
      @item4 = @merch2.items.create!(name: 'Goopy Original', description: 'the bester', unit_price: 1450)
      @item5 = @merch2.items.create!(name: 'Goopy Updated', description: 'the even better', unit_price: 1950)

      @cust1 = Customer.create!(first_name: "Mark", last_name: "Ruffalo")

      @inv1 = @cust1.invoices.create!(status: "in progress")
      @inv2 = @cust1.invoices.create!(status: "completed")

      InvoiceItem.create!(item_id: "#{@item1.id}", invoice_id: "#{@inv1.id}")
      InvoiceItem.create!(item_id: "#{@item4.id}", invoice_id: "#{@inv2.id}")
    end

    it 'shows me the admin invoice index page with all the invoices' do
#       As an admin,
      # When I visit the admin Invoices index ("/admin/invoices")
      # Then I see a list of all Invoice ids in the system
      # Each id links to the admin invoice show page

      visit("/admin/invoices")

      expect(page).to have_content(@inv1.name)
      expect(page).to have_content(@inv2.name)
      expect(page).to have_link(@inv1.id)
      expect(page).to have_link(@inv2.id)

      click_link(@inv1.id)
      expect(current_path).to eq("/admin/invoices/#{@inv1.id}")
      expect(page).to have_content(@inv1.name)

    end


end
