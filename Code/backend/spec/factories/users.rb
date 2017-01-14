FactoryGirl.define do
  factory :invalid_empty_type_user, class: User do
    type ""
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :invalid_nil_type_user, class: User do
    type nil
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :invalid_wrong_type_user, class: User do
    type { Faker::Name.first_name }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :create_wrong_type_user_params, class: Hash do
    type { Faker::Name.first_name }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    initialize_with { attributes }
  end
end
