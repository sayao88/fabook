class RemoveColumnContacts < ActiveRecord::Migration
  def up
    remove_column :contacts, :title , :string
  end
  def down
    add_column :contacts, :title , :string
  end
end
