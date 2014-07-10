Fabricator(:payment) do 
  amount { Faker::Number.number(3)}
  reference_id { Faker::Lorem.characters(10) }
end
