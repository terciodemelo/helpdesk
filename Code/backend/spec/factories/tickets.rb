FactoryGirl.define do
  factory :ticket do
    status { %w(OPEN CLOSED).sample }
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    association :author, :factory => :customer
  end

  factory :invalid_nil_title_ticket, class: Ticket do
    status { %w(OPEN CLOSED).sample }
    title nil
    body { Faker::Lorem.paragraph }
    association :author, :factory => :customer
  end

  factory :invalid_empty_title_ticket, class: Ticket do
    status { %w(OPEN CLOSED).sample }
    title ""
    body { Faker::Lorem.paragraph }
    association :author, :factory => :customer
  end

  factory :invalid_nil_body_ticket, class: Ticket do
    status { %w(OPEN CLOSED).sample }
    title { Faker::Lorem.sentence }
    body nil
    association :author, :factory => :customer
  end

  factory :invalid_empty_body_ticket, class: Ticket do
    status { %w(OPEN CLOSED).sample }
    title { Faker::Lorem.sentence }
    body ""
    association :author, :factory => :customer
  end

  factory :invalid_wrong_status_ticket, class: Ticket do
    status { Faker::Lorem.word }
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    association :author, :factory => :customer
  end
end
