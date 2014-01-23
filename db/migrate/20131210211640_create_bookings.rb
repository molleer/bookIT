class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :cid
      t.datetime :start
      t.datetime :end
      t.string :group
      t.text :description
      t.string :festansvarig
      t.string :festnumber
      t.references :room, index: true

      t.timestamps
    end
  end
end
