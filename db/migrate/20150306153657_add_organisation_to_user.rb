class AddOrganisationToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :organisation, :string
  end
end
