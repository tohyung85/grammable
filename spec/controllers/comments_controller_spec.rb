require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "comments#create action" do 
    it "should allow user to create comments on grams" do 
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      
      sign_in user

      post :create, gram_id: gram.id, comment: {message: 'awesome gram'}

      expect(response).to redirect_to root_path
      expect(gram.comments.length).to eq 1
      expect(gram.comments.first.message).to eq 'awesome gram'
    end

    it "should require a user to be logged in to create comments" do 
      gram = FactoryGirl.create(:gram)
      post :create, gram_id: gram.id, comment: {message: 'test'}

      expect(response).to redirect_to new_user_session_path

    end

    it "should return a http status code of not found if gram isn't found" do 
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, gram_id: 'something', comment: {message: 'lala'}

      expect(response).to have_http_status :not_found

    end
  end

end
