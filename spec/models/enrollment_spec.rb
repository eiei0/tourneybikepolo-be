# frozen_string_literal: true

require "rails_helper"

describe Enrollment, type: :model do
  it { should have_many(:registrations) }
  it { should belong_to(:team) }
  it { should belong_to(:tournament) }
end
