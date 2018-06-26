# frozen_string_literal: true

class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: [:show, :update, :destroy]

  def index
    @enrollments = Enrollment.all

    render json: @enrollments
  end

  def show
    render json: @enrollment
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)

    if @enrollment.save
      render json: @enrollment, status: :created, location: @enrollment
    else
      render json: @enrollment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @enrollment.update(enrollment_params)
      render json: @enrollment
    else
      render json: @enrollment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @enrollment.destroy
  end

  private

  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  def enrollment_params
    params.require(:enrollment).permit(:team_id, :tournament_id)
  end
end
