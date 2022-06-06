require 'rails_helper'

RSpec.describe "Admin Invoice Show" do
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

      @ii1 = InvoiceItem.create!(item_id: "#{@item1.id}", invoice_id: "#{@inv1.id}", quantity: 100, unit_price: 1000, status: 1)
      @ii2 = InvoiceItem.create!(item_id: "#{@item2.id}", invoice_id: "#{@inv1.id}", quantity: 200, unit_price: 2000, status: 1)
      @ii3 = InvoiceItem.create!(item_id: "#{@item4.id}", invoice_id: "#{@inv2.id}", quantity: 300)
    end

    it 'displays invoice information including id, status, customer and created at' do
      visit("/admin/invoices/#{@inv1.id}")

      expect(page).to have_content("#{@inv1.id}")
      expect(page).to have_content("#{@inv1.status}")
      expect(page).to have_content(@inv1.created_at.strftime('%A, %B%e, %Y'))
      expect(page).to have_content("Mark Ruffalo")
    end

    it "displays all items and their attributes" do
      visit("/admin/invoices/#{@inv1.id}")
      within "#invoice-item-#{@ii1.id}" do
        expect(page).to have_content("Item Name: Floopy Original")
        expect(page).to have_content("Quantity: 100")
        expect(page).to have_content("Unit Price: 10.00")
        expect(page).to have_content("Status: packaged")
        expect(page).to_not have_content("Floopy Updated")
        expect(page).to_not have_content("Floopy Retro")
      end
      within "#invoice-item-#{@ii2.id}" do
        expect(page).to have_content("Floopy Updated")
        expect(page).to have_content("Quantity: 200")
        expect(page).to have_content("Unit Price: 20.00")
        expect(page).to have_content("Status: packaged")
        expect(page).to_not have_content("Floopy Retro")
        expect(page).to_not have_content("Floopy Original")
      end
    end
    


end
