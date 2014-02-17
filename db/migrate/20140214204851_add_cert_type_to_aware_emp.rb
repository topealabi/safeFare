class AddCertTypeToAwareEmp < ActiveRecord::Migration
  def change
  	add_column :aware_employees, :cert_type, :string, null:false
  end
end
