require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "grams #destroy action" do
    it "shouldn't allow a user who did not create the gram destroy it" do 
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, id: gram.id
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated user destroy a gram" do 
      gram = FactoryGirl.create(:gram)
      delete :destroy, id: gram.id
      expect(response).to redirect_to new_user_session_path
    end


    it "should allow users to successfully destroy gram" do
      gram = FactoryGirl.create(:gram, message: 'some message')
      sign_in gram.user
      delete :destroy, id: gram.id
      expect(response).to redirect_to root_path

      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end

    it "should return a 404 error if id not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, id: 'kaboom'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#update action" do 
    it "shouldn't let a user who did not create the gram to update it" do
      gram = FactoryGirl.create(:gram, message: 'initial value')
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, id: gram.id, gram: {message: 'changed'}
      expect(response).to have_http_status(:forbidden)

    end


    it "shouldn't let unauthenticated user update a gram" do
      gram = FactoryGirl.create(:gram, message: 'Initial value')
      patch :update, id: gram.id, gram: {message: 'changed'}
      expect(response).to redirect_to new_user_session_path
      gram.reload
      expect(gram.message).to eq('Initial value')
    end

    it "should allow users to successfully update gram" do
      gram = FactoryGirl.create(:gram, message: 'Initial Value')
      sign_in gram.user
      patch :update, id: gram.id, gram: {message: 'changed'}
      expect(response).to redirect_to root_path

      gram.reload

      expect(gram.message).to eq('changed')

    end

    it "should have http 404 error if gram is not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, id: "YOLO", gram: {message: 'changed'}
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form if an http status of unprocessable entity" do
      gram = FactoryGirl.create(:gram, message: 'Initial Value')
      sign_in gram.user
      patch :update, id: gram.id, gram: {message: ''}
      expect(response).to have_http_status(:unprocessable_entity)

      gram.reload

      expect(gram.message).to eq('Initial Value')
    end

  end

  describe "grams#edit action" do
    it "shouldn't let a user who did not create the gram edit the gram" do
      gram = FactoryGirl.create(:gram)      
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, id: gram.id
      expect(response).to have_http_status(:forbidden)
    end


    it "shouldn't let unauthenticated user edit a gram" do
      gram = FactoryGirl.create(:gram)
      get :edit, id: gram.id
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show edit form if gram is found" do 
      gram = FactoryGirl.create(:gram)
      sign_in gram.user
      get :edit, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if gram is not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, id: "123"
      expect(response).to have_http_status(:not_found)
    end
  end


  describe "grams#show action" do 
    it "should successfully show the page if gram is found" do
      gram = FactoryGirl.create(:gram)
      get :show, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if gram is not found" do 
      get :show, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#index action" do 
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do
    it "should require users to be logged in" do
      get :new

      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully display form" do
      user = FactoryGirl.create(:user)

      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "Should require user to be logged in" do 
      post :create, gram: { message: 'Hello' }
      expect(response).to redirect_to new_user_session_path
    end


    it "should successfully create a gram in our database" do
      user = FactoryGirl.create(:user)

      sign_in user

      post :create, gram: { message: 'Hello!'}
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)

      sign_in user
      post :create, gram: {message: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end
  end

end
