FactoryGirl.define do
  factory :admin do
    type "Admin"
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :create_admin_params, class: Hash do
    type "Admin"
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    initialize_with { attributes }
  end

  factory :invalid_wrong_type_admin, class: Admin do
    type  { Faker::Name.first_name }
    name  { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :invalid_empty_name_admin, class: Admin do
    type "Admin"
    name ""
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :invalid_nil_name_admin, class: Admin do
    type "Admin"
    name nil
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :invalid_empty_email_admin, class: Admin do
    type "Admin"
    name { Faker::Name.name }
    email ""
    password { Faker::Internet.password }
  end

  factory :invalid_nil_email_admin, class: Admin do
    type "Admin"
    name ""
    email nil
    password { Faker::Internet.password }
  end

  factory :invalid_empty_password_admin, class: Admin do
    type "Admin"
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password ""
  end

  factory :invalid_nil_password_admin, class: Admin do
    type "Admin"
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password nil
  end
end
