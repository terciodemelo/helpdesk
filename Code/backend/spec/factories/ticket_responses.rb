FactoryGirl.define do
  factory :ticket_response do
    body { Faker::Lorem.paragraph }
    association :ticket
    association :author, :factory => :customer
  end

  factory :invalid_empty_ticket_response, class: TicketResponse do
    body ""
    association :ticket
    association :author, :factory => :customer
  end

  factory :invalid_nil_ticket_response, class: TicketResponse do
    body nil
    association :ticket
    association :author, :factory => :customer
  end
end
