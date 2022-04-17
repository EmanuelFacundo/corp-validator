require "test_helper"

class FinancialTittlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @financial_tittle = financial_tittles(:one)
  end

  test "should get index" do
    get financial_tittles_url
    assert_response :success
  end

  test "should get new" do
    get new_financial_tittle_url
    assert_response :success
  end

  test "should create financial_tittle" do
    assert_difference("FinancialTittle.count") do
      post financial_tittles_url, params: { financial_tittle: { cnpj_assignor: @financial_tittle.cnpj_assignor, cnpj_payer: @financial_tittle.cnpj_payer, expiration_date: @financial_tittle.expiration_date, number: @financial_tittle.number, value: @financial_tittle.value } }
    end

    assert_redirected_to financial_tittle_url(FinancialTittle.last)
  end

  test "should show financial_tittle" do
    get financial_tittle_url(@financial_tittle)
    assert_response :success
  end

  test "should get edit" do
    get edit_financial_tittle_url(@financial_tittle)
    assert_response :success
  end

  test "should update financial_tittle" do
    patch financial_tittle_url(@financial_tittle), params: { financial_tittle: { cnpj_assignor: @financial_tittle.cnpj_assignor, cnpj_payer: @financial_tittle.cnpj_payer, expiration_date: @financial_tittle.expiration_date, number: @financial_tittle.number, value: @financial_tittle.value } }
    assert_redirected_to financial_tittle_url(@financial_tittle)
  end

  test "should destroy financial_tittle" do
    assert_difference("FinancialTittle.count", -1) do
      delete financial_tittle_url(@financial_tittle)
    end

    assert_redirected_to financial_tittles_url
  end
end
