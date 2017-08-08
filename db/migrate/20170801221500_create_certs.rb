class CreateCerts < ActiveRecord::Migration
  def change
    create_table :certs do |t|
      t.integer :user_id
      t.string :owner_email, limit: 64, index: true
      t.timestamp :imported_at
      t.string :profile, limit: 16
      t.text :subject
      t.text :issuer
      t.string :serial_number, limit: 255
      t.text :sans
      t.timestamp :not_before
      t.timestamp :not_after, index: true
      t.string :sigalg, limit: 16
      t.string :authority_key_id, limit: 255
      t.string :subject_key_id, limit: 255
      t.text :pem, null: false
      t.text :key
    end
  end
end
