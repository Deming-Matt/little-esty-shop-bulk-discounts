require 'rails_helper'

RSpec.describe 'merchants items index' do

  it 'shows the name of the items belonging to a merchant' do
    # As a merchant,
    # When I visit my merchant items index page ("merchant/merchant_id/items")
    # I see a list of the names of all of my items
    # And I do not see items for any other merchant
    merch1 = Merchant.create!(name: 'Floopy Fopperations')
    item1 = merch1.items.create!(name: 'Floopy Original', description: 'the best', unit_price: 450)
    item2 = merch1.items.create!(name: 'Floopy Updated', description: 'the better', unit_price: 950)
    item3 = merch1.items.create!(name: 'Floopy Retro', description: 'the OG', unit_price: 550)

    merch2 = Merchant.create!(name: 'Goopy Gopperations')
    item4 = merch2.items.create!(name: 'Goopy Original', description: 'the bester', unit_price: 1450)
    item5 = merch2.items.create!(name: 'Goopy Updated', description: 'the even better', unit_price: 1950)

    visit "/merchants/#{merch1.id}/items"

    # save_and_open_page

    expect(page).to have_content(merch1.name)
    expect(page).to have_content(item1.name)
    expect(page).to have_content(item2.name)
    expect(page).to have_content(item3.name)
    expect(page).to_not have_content(item4.name)
    expect(page).to_not have_content(item5.name)

  end

  it 'allows me to enable / disable items belonging to a merchant' do
    # As a merchant
    # When I visit my items index page
    # Next to each item name I see a button to disable or enable that item.
    # When I click this button
    # Then I am redirected back to the items index
    # And I see that the items status has changed
    merch1 = Merchant.create!(name: 'Floopy Fopperations')
    item1 = merch1.items.create!(name: 'Floopy Original', description: 'the best', unit_price: 450, status: 0)
    item2 = merch1.items.create!(name: 'Floopy Updated', description: 'the better', unit_price: 950, status: 1)

    visit "/merchants/#{merch1.id}/items"
    # save_and_open_page

    within "#item-#{item1.id}" do
      expect(page).to have_content(item1.name)
      expect(page).to have_content(item1.status)
      expect(page).to have_button("Enable #{item1.name}")

      expect(page).to_not have_content(item2.name)
      expect(page).to_not have_content(item2.status)
      expect(page).to_not have_button("Disable #{item2.name}")
      expect(page).to_not have_button("Enable #{item2.name}")

      expect(page).to have_content("Current Status: disabled")
    end

    within "#item-#{item2.id}" do
      expect(page).to_not have_content(item1.name)
      expect(page).to_not have_content(item1.status)
      expect(page).to_not have_button("Disable #{item1.name}")
      expect(page).to_not have_button("Enable #{item1.name}")

      expect(page).to have_content(item2.name)
      expect(page).to have_content(item2.status)
      expect(page).to have_button("Disable #{item2.name}")
      expect(page).to have_content("Current Status: enabled")
    end


    click_button "Enable #{item1.name}"
    expect(current_path).to eq("/merchants/#{merch1.id}/items/")
    within "#item-#{item1.id}" do
      expect(page).to have_content("Current Status: enabled")
    end

    click_button "Disable #{item2.name}"
    expect(current_path).to eq("/merchants/#{merch1.id}/items/")
    within "#item-#{item2.id}" do
      expect(page).to have_content("Current Status: disabled")
    end
  end

  it 'groups the items by enabled or disabled status' do
    # As a merchant,
    # When I visit my merchant items index page
    # Then I see two sections, one for "Enabled Items" and one for "Disabled Items"
    # And I see that each Item is listed in the appropriate section
    merch1 = Merchant.create!(name: 'Floopy Fopperations')
    item1 = merch1.items.create!(name: 'Floopy Original', description: 'the best', unit_price: 450, status: 0)
    item2 = merch1.items.create!(name: 'Floopy Updated', description: 'the better', unit_price: 950, status: 1)
    item3 = merch1.items.create!(name: 'Floopy Remix', description: 'the even better', unit_price: 1950, status: 0)
    item4 = merch1.items.create!(name: 'Floopy Retro', description: 'the OG', unit_price: 2950, status: 1)

    visit "/merchants/#{merch1.id}/items"

    # save_and_open_page

    expect(page).to have_content("Enabled Items")
    expect(page).to have_content("Disabled Items")

    within "#enabled-items" do
      expect(page).to have_content(item2.name)
      expect(page).to have_content(item4.name)
    end

    within "#disabled-items" do
      expect(page).to have_content(item1.name)
      expect(page).to have_content(item3.name)
    end

  end

  it 'can add an create a merchant item and have the default value be disabled' do
    # As a merchant
    # When I visit my items index page
    # I see a link to create a new item.
    # When I click on the link,
    # I am taken to a form that allows me to add item information.
    # When I fill out the form I click ‘Submit’
    # Then I am taken back to the items index page
    # And I see the item I just created displayed in the list of items.
    # And I see my item was created with a default status of disabled.
    merch1 = Merchant.create!(name: 'Floopy Fopperations')
    item1 = merch1.items.create!(name: 'Floopy Original', description: 'the best', unit_price: 450, status: 0)
    item2 = merch1.items.create!(name: 'Floopy Updated', description: 'the better', unit_price: 950, status: 1)
    item3 = merch1.items.create!(name: 'Floopy Remix', description: 'the even better', unit_price: 1950, status: 0)

    visit "/merchants/#{merch1.id}/items"

    click_link "Create a new Item"
    expect(current_path).to eq("/merchants/#{merch1.id}/items/new")

    # save_and_open_page

    fill_in 'Name', with: 'Floopy Retro'
    fill_in 'Description', with: 'the OG'
    fill_in 'unit_price', with: 1950

    click_button "Submit"
    expect(current_path).to eq("/merchants/#{merch1.id}/items")

    within "#disabled-items" do
      expect(page).to have_content('Floopy Retro')
    end

    within "#enabled-items" do
      expect(page).to_not have_content('Floopy Retro')
    end

  end


end
