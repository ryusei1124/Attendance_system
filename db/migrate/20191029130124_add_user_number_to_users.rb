class AddUserNumberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employee_number, :string
    add_column :users, :uid, :string
    add_column :users, :designated_work_end_time, :datetime, default: Time.current.change(hour: 17, min: 0, sec: 0)
  end
end
