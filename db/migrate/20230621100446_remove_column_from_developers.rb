class RemoveColumnFromDevelopers < ActiveRecord::Migration[7.0]
  def change
    remove_column :developers, :image_url, :string
  end
end
