class AddEmployeeRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_employee, :boolean, default: false
    add_column :users, :job_title, :string
    add_index :users, :is_employee
  end
end
