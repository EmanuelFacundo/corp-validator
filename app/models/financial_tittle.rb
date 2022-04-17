# frozen_string_literal: true

class FinancialTittle < ApplicationRecord
  require 'net/http'

  validates :number, presence: true
  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :expiration_date, presence: true, format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }
  validates :cnpj_assignor, presence: true, format: { with: %r{\A\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}\z} }
  validates :cnpj_payer, presence: true, format: { with: %r{\A\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}\z} }

  serialize :cnpj_assignor_protest, Hash
  serialize :cnpj_payer_protest, Hash

  validate :validate_expiration_date
  validate :already_exists, on: :create

  scope :have_critic_protest, -> { where.not(cnpj_assignor_protest: nil, cnpj_payer_protest: nil) }

  private

  def validate_expiration_date
    return unless expiration_date.present? && expiration_date < Date.today

    errors.add(:expiration_date, 'Expiration date must be greater than date today')
  end

  def already_exists
    errors.add(:number, 'Title already exists') if FinancialTittle.where(number:, cnpj_assignor:).exists?
  end
end
