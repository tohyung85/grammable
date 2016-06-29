FactoryGirl.define do 
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"
  end

  factory :gram do
    message "hello"
    picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'logoTP.png'), 'image/png')}
    association :user
  end

  factory :comment do
    message "blah blah"
    association :user
    association :gram
  end
  
end