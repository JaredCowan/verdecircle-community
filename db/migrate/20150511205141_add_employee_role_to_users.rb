class AddEmployeeRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_employee, :boolean, default: false
    add_index :users, :is_employee
  end
end
