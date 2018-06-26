# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationsController, type: :controller do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all registrations as @registrations" do
      registration = Registration.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:registrations)).to eq([registration])
    end
  end

  describe "GET #show" do
    it "assigns the requested registration as @registration" do
      registration = Registration.create! valid_attributes
      get :show, params: {id: registration.to_param}, session: valid_session
      expect(assigns(:registration)).to eq(registration)
    end
  end

  describe "GET #new" do
    it "assigns a new registration as @registration" do
      get :new, params: {}, session: valid_session
      expect(assigns(:registration)).to be_a_new(Registration)
    end
  end

  describe "GET #edit" do
    it "assigns the requested registration as @registration" do
      registration = Registration.create! valid_attributes
      get :edit, params: {id: registration.to_param}, session: valid_session
      expect(assigns(:registration)).to eq(registration)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Registration" do
        expect {
          post :create, params: {registration: valid_attributes}, session: valid_session
        }.to change(Registration, :count).by(1)
      end

      it "assigns a newly created registration as @registration" do
        post :create, params: {registration: valid_attributes}, session: valid_session
        expect(assigns(:registration)).to be_a(Registration)
        expect(assigns(:registration)).to be_persisted
      end

      it "redirects to the created registration" do
        post :create, params: {registration: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Registration.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved registration as @registration" do
        post :create, params: {registration: invalid_attributes}, session: valid_session
        expect(assigns(:registration)).to be_a_new(Registration)
      end

      it "re-renders the 'new' template" do
        post :create, params: {registration: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested registration" do
        registration = Registration.create! valid_attributes
        put :update, params: {id: registration.to_param, registration: new_attributes}, session: valid_session
        registration.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested registration as @registration" do
        registration = Registration.create! valid_attributes
        put :update, params: {id: registration.to_param, registration: valid_attributes}, session: valid_session
        expect(assigns(:registration)).to eq(registration)
      end

      it "redirects to the registration" do
        registration = Registration.create! valid_attributes
        put :update, params: {id: registration.to_param, registration: valid_attributes}, session: valid_session
        expect(response).to redirect_to(registration)
      end
    end

    context "with invalid params" do
      it "assigns the registration as @registration" do
        registration = Registration.create! valid_attributes
        put :update, params: {id: registration.to_param, registration: invalid_attributes}, session: valid_session
        expect(assigns(:registration)).to eq(registration)
      end

      it "re-renders the 'edit' template" do
        registration = Registration.create! valid_attributes
        put :update, params: {id: registration.to_param, registration: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested registration" do
      registration = Registration.create! valid_attributes
      expect {
        delete :destroy, params: {id: registration.to_param}, session: valid_session
      }.to change(Registration, :count).by(-1)
    end

    it "redirects to the registrations list" do
      registration = Registration.create! valid_attributes
      delete :destroy, params: {id: registration.to_param}, session: valid_session
      expect(response).to redirect_to(registrations_url)
    end
  end

end
