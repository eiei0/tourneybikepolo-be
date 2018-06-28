# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rosters", type: :request do
  describe "POST /rosters" do
    it "returns a successful 201 created response" do
      team = create(:team)
      user = create(:user)
      successful_params = { team_id: team.id, player_id: user.id }

      post rosters_path(team, user),
        headers: authenticated_header,
        params: { roster: successful_params }

      expect(response).to have_http_status(201)
    end

    it "successfully creates an enrollment with the params sent" do
      team = create(:team)
      user = create(:user)
      successful_params = { team_id: team.id, player_id: user.id, role: 1 }

      post rosters_path(team, user),
        headers: authenticated_header,
        params: { roster: successful_params }


      expect(json_response_struct.team_id).to eq(team.id)
      expect(json_response_struct.player_id).to eq(user.id)
      expect(json_response_struct.role).to eq(1)
    end
  end

  describe "PATCH /rosters/:id" do
    it "returns a successful 200 response" do
      roster = create :roster, role: 1
      successful_params = { role: 2 }

      patch roster_path(roster),
        headers: authenticated_header,
        params: { roster: successful_params }

      expect(response).to have_http_status(200)
    end

    it "successfully updates the roster with the params sent" do
      roster = create :roster, role: 1
      successful_params = { role: 2 }

      expect {
        patch roster_path(roster), headers: authenticated_header, params: { roster: successful_params }
      }.to change { roster.reload.role }.from(1).to(2)
    end

    it "returns a not found 404 response" do
      delete roster_path(id: 1), headers: authenticated_header

      expect(response).to have_http_status(404)
    end

    it "returns an unauthorized 401 response" do
      patch roster_path(id: 1)

      expect(response).to have_http_status(401)
    end
  end

  describe "DELETE /rosters/:id" do
    it "returns a successful 204 response" do
      roster = create(:roster)

      delete roster_path(roster), headers: authenticated_header

      expect(response).to have_http_status(204)
    end

    it "successfully deletes the enrollment with the params sent" do
      roster = create(:roster)
      expect { delete roster_path(roster), headers: authenticated_header }
        .to change { Roster.count }
        .from(1)
        .to(0)
    end
  end
end
