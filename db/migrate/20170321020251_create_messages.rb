class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.references :conversation, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      # nil（無） が入らないようにするために、デフォルト値を指定
      t.boolean :read, default: false

      t.timestamps null: false
    end
  end
end
