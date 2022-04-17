# frozen_string_literal: true

class FinancialTittlesController < ApplicationController
  include CheckFinancialTittleConcern

  skip_before_action :verify_authenticity_token, on: :create

  before_action :validate_params_search, on: :index

  def index
    financial_tittles = FinancialTittle.where(financial_tittle_search_params)
    @financial_tittles = financial_tittles.order(expiration_date: :desc)

    render json: @financial_tittles
  end

  def create
    response_data = []
    financial_tittle_params.each do |financial_tittle_param|
      create_financial_tittle(financial_tittle_param.permit!)
    rescue StandardError => e
      response_data << {
        financial_tittle: financial_tittle_param,
        error: e.message
      }
    end

    render json: response_data, status: :unprocessable_entity and return unless response_data.empty?

    render json: { message: 'All financial tittles were successfully created.' }
  end

  private

  def financial_tittle_search_params
    params.permit(:cnpj_assignor, :cnpj_payer, :expiration_date, :have_critic_protest, :number)
  end

  def validate_params_search
    return if financial_tittle_search_params.blank?

    error_messages = []
    financial_tittle_search_params.each do |key, value|
      next if value.blank?

      case key.to_sym
      when :cnpj_assignor
        unless value.match?(%r{\A\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}\z})
          error_messages << 'CNPJ Assignor must be a valid CNPJ'
        end
      when :cnpj_payer
        error_messages << 'CNPJ Payer must be a valid CNPJ' unless value.match?(%r{\A\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}\z})
      when :expiration_date
        error_messages << 'Expiration date must be a valid date' unless value.match?(/\A\d{4}-\d{2}-\d{2}\z/)
      when :have_critic
        error_messages << 'Have critic must be a boolean' unless value.match?(/\A(true|false)\z/)
      when :number
        error_messages << 'Number must be a valid number' unless value.match?(/\A[a-zA-Z0-9]\z/)
      end
    end

    return if error_messages.empty?

    render json: { message: error_messages.join(', ') }, status: :unprocessable_entity and return
  end

  def financial_tittle_params
    params.permit(_json: %i[number value expiration_date cnpj_assignor cnpj_payer])
    params[:_json]
  end

  def create_financial_tittle(financial_tittle_param)
    @financial_tittle = FinancialTittle.new(financial_tittle_param)

    raise StandardError, @financial_tittle.errors.full_messages.join(', ') unless @financial_tittle.save

    cnpj_assignor_protest = check_cnpj_assignor_protest(@financial_tittle.cnpj_assignor)
    cnpj_payer_protest = check_cnpj_payer_protest(@financial_tittle.cnpj_payer)
    status = check_tittle_status(@financial_tittle.number)
    @financial_tittle.update(
      cnpj_assignor_protest:,
      cnpj_payer_protest:,
      status:
    )
  end
end
