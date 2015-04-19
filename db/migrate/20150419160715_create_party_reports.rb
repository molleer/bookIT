class CreatePartyReports < ActiveRecord::Migration
  def change
    create_table :party_reports do |t|
      t.references :booking, index: true, foreign_key: true
      t.string :party_responsible_name
      t.string :party_responsible_phone
      t.string :party_responsible_mail
      t.string :co_party_responsible_name
      t.string :co_party_responsible_phone
      t.string :co_party_responsible_mail
      t.boolean :liquor_license
      t.boolean :sent
      t.boolean :accepted
      t.datetime :begin_date
      t.datetime :end_date

      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
