class CreateFinancialTittles < ActiveRecord::Migration[7.0]
  def change
    create_table :financial_tittles do |t|
      t.string :number, null: false
      t.decimal :value, null: false
      t.date :expiration_date, null: false
      t.string :cnpj_assignor, null: false
      t.string :cnpj_payer, null: false
      t.string :status
      t.json :cnpj_assignor_protest
      t.json :cnpj_payer_protest

      t.timestamps
    end
  end
end
