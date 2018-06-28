# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_registration, only: [:show, :update, :destroy]

  def show
    render json: @registration
  end

  def create
    registration = Registration.new(registration_params)

    if registration.save
      render json: registration, status: :created, location: registration
    else
      render json: registration.errors, status: :unprocessable_entity
    end
  end

  def update
    if @registration.update(registration_params)
      render json: @registration
    else
      render json: @registration.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @registration.destroy
  end

  private

  def set_registration
    @registration = Registration.find(params[:id])
  rescue
    error = { errors: { message: "Not Found" } }.to_json
    render json: error, status: :not_found unless @registration
  end

  def registration_params
    params.require(:registration).permit(
      :team_id, :user_id, :enrollment_id, :status
    )
  end
end
