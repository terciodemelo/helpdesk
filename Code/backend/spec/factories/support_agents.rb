FactoryGirl.define do
  factory :support_agent do
    type "SupportAgent"
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :create_support_agent_params, class: Hash do
    type "SupportAgent"
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    initialize_with { attributes }
  end

  factory :invalid_wrong_type_support_agent, class: SupportAgent do
    type  { Faker::Name.first_name }
    name  { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :invalid_empty_name_support_agent, class: SupportAgent do
    type "SupportAgent"
    name ""
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :invalid_nil_name_support_agent, class: SupportAgent do
    type "SupportAgent"
    name nil
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :invalid_empty_email_support_agent, class: SupportAgent do
    type "SupportAgent"
    name { Faker::Name.name }
    email ""
    password { Faker::Internet.password }
  end

  factory :invalid_nil_email_support_agent, class: SupportAgent do
    type "SupportAgent"
    name ""
    email nil
    password { Faker::Internet.password }
  end

  factory :invalid_empty_password_support_agent, class: SupportAgent do
    type "SupportAgent"
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password ""
  end

  factory :invalid_nil_password_support_agent, class: SupportAgent do
    type "SupportAgent"
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password nil
  end
end
