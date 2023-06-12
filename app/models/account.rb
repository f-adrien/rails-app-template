# frozen_string_literal: true

# Purpose: Account model for the application. This model is used to store
class Account < ApplicationRecord
  has_many :account_users, dependent: :destroy
  has_many :users, through: :account_users
end
