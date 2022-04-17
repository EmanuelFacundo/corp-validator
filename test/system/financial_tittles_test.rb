require "application_system_test_case"

class FinancialTittlesTest < ApplicationSystemTestCase
  setup do
    @financial_tittle = financial_tittles(:one)
  end

  test "visiting the index" do
    visit financial_tittles_url
    assert_selector "h1", text: "Financial tittles"
  end

  test "should create financial tittle" do
    visit financial_tittles_url
    click_on "New financial tittle"

    fill_in "Cnpj assignor", with: @financial_tittle.cnpj_assignor
    fill_in "Cnpj payer", with: @financial_tittle.cnpj_payer
    fill_in "Expiration date", with: @financial_tittle.expiration_date
    fill_in "Number", with: @financial_tittle.number
    fill_in "Value", with: @financial_tittle.value
    click_on "Create Financial tittle"

    assert_text "Financial tittle was successfully created"
    click_on "Back"
  end

  test "should update Financial tittle" do
    visit financial_tittle_url(@financial_tittle)
    click_on "Edit this financial tittle", match: :first

    fill_in "Cnpj assignor", with: @financial_tittle.cnpj_assignor
    fill_in "Cnpj payer", with: @financial_tittle.cnpj_payer
    fill_in "Expiration date", with: @financial_tittle.expiration_date
    fill_in "Number", with: @financial_tittle.number
    fill_in "Value", with: @financial_tittle.value
    click_on "Update Financial tittle"

    assert_text "Financial tittle was successfully updated"
    click_on "Back"
  end

  test "should destroy Financial tittle" do
    visit financial_tittle_url(@financial_tittle)
    click_on "Destroy this financial tittle", match: :first

    assert_text "Financial tittle was successfully destroyed"
  end
end
