class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.string :name
      t.string :email
      t.string :uid
      t.string :organisation_slug
      t.string :organisation_content_id
      t.string :permissions
      t.boolean :remotely_signed_out, default: false
      t.boolean :disabled, default: false

      t.timestamps null: false
    end
  end
end
