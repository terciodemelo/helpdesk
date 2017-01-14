FactoryGirl.define do
  factory :customer do
    type "Customer"
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :create_customer_params, class: Hash do
    type "Customer"
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    initialize_with { attributes }
  end

  factory :invalid_wrong_type_customer, class: Customer do
    type  { Faker::Name.first_name }
    name  { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :invalid_empty_name_customer, class: Customer do
    type "Customer"
    name ""
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :invalid_nil_name_customer, class: Customer do
    type "Customer"
    name nil
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :invalid_empty_email_customer, class: Customer do
    type "Customer"
    name { Faker::Name.name }
    email ""
    password { Faker::Internet.password }
  end

  factory :invalid_nil_email_customer, class: Customer do
    type "Customer"
    name ""
    email nil
    password { Faker::Internet.password }
  end

  factory :invalid_empty_password_customer, class: Customer do
    type "Customer"
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password ""
  end

  factory :invalid_nil_password_customer, class: Customer do
    type "Customer"
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password nil
  end
end
