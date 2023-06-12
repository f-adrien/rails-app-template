# frozen_string_literal: true

# Purpose: User model for the application. This model is used by Devise for authentication.
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable

  has_many :account_users, dependent: :destroy
  has_many :accounts, through: :account_users
end
