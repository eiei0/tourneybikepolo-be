# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :rosters
  has_many :players, through: :rosters
  has_many :enrollments
  has_many :tournaments, through: :enrollments
  has_many :registrations

  validates :name, presence: true
end
