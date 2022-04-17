# frozen_string_literal: true

module CheckFinancialTittleConcern
  extend ActiveSupport::Concern

  def check_cnpj_assignor_protest(cnpj_assignor)
    uri = URI.parse(EndpointsToValidate::PROTEST_CNPJ + cnpj_assignor)
    request_external_api(uri).first
  end

  def check_cnpj_payer_protest(cnpj_payer)
    uri = URI.parse(EndpointsToValidate::PROTEST_CNPJ + cnpj_payer)
    request_external_api(uri).first
  end

  def check_tittle_status(number)
    uri = URI.parse(EndpointsToValidate::TITTLE_ALREADY_EXISTS + number)
    request_external_api(uri)['status']
  end

  def request_external_api(uri, retries = 3)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 0.5

    response = http.request_get(uri.request_uri)

    JSON.parse(response.body)
  rescue Net::OpenTimeout => e
    Rails.logger.error "TRY #{retries} more times\n #{e.message}"

    raise if retries <= 1

    request_external_api(uri, retries - 1)
  end
end
