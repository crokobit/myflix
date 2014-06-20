include ActionDispatch::TestProcess
Fabricator(:video) do
  title { Faker::Name.name }
  description Faker::Name.name
  large_cover {fixture_file_upload(Rails.root.join('public', 'tmp', 'monk_large.jpg'), 'image/jpg')}
  small_cover {fixture_file_upload(Rails.root.join('public', 'tmp',["family_guy","futurama","monk","south_park"].sample + ".jpg"), 'image/jpg')}  
  url {Faker::Internet.url}
end

Fabricator(:category) do
  name Faker::Name.name
end
