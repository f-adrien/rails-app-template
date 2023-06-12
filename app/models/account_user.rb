# frozen_string_literal: true

# Purpose: AccountUser model. This model is used to associate a user with an account.
class AccountUser < ApplicationRecord
  belongs_to :account
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :account_id
end
