class CreateRefreshTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :refresh_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :secret, null: false
      t.datetime :expires_at, null: false
      t.datetime :revoked_at
      t.datetime :replaced_at


      t.timestamps
    end
  end
end