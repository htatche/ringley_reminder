class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :estate_code
      t.string :period
      t.string :due_date

      t.timestamps
    end
  end
end
