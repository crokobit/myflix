# This m33k should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
#
#
#
#

# sport = Category.create(name: 'sport')
# news = Category.create(name: 'news')
#
# video2 = Video.create(title: 'title2', description: 'test2', small_cover_url: "/tmp/futurama.jpg", big_cover_url: "/tmp/monk_large.jpg")
# video3 = Video.create(title: 'title3', description: 'test', small_cover_url: "/tmp/futurama.jpg", big_cover_url: "/tmp/monk_large.jpg")
# video4 = Video.create(title: 'title4', description: 'test', small_cover_url: "/tmp/futurama.jpg", big_cover_url: "/tmp/monk_large.jpg")
# video5 = Video.create(title: 'title5', description: 'test', small_cover_url: "/tmp/futurama.jpg", big_cover_url: "/tmp/monk_large.jpg")
# video6 = Video.create(title: 'title6', description: 'test2', small_cover_url: "/tmp/futurama.jpg", big_cover_url: "/tmp/monk_large.jpg")
# video7 = Video.create(title: 'title7', description: 'test2', small_cover_url: "/tmp/futurama.jpg", big_cover_url: "/tmp/monk_large.jpg")
# video8 = Video.create(title: 'title8', description: 'test2', small_cover_url: "/tmp/futurama.jpg", big_cover_url: "/tmp/monk_large.jpg")
#
#
# sport.videos << video2
# sport.videos << video3
# sport.videos << video4
# sport.videos << video5
# sport.videos << video6
# news.videos << video7
# news.videos << video8


sport = Fabricate(:category, name: "sport")
news = Fabricate(:category, name: "news")
grammer = Fabricate(:category, name: "grammer")

keroro = Fabricate(:user, name: "keroro")
ivan = Fabricate(:user, name: "ivan")
eva = Fabricate(:user, name: "eva")

user = User.create(name: "crokobit", password: "pw", email: "crokobit@gmail.com", admin: true)
Payment.create(id: 4, reference_id: "ch_14IfSv4zdTxaHvAkH1ue8la5", amount: 2000, customer_id: user.id, start_time: Time.at(1405944025), end_time: Time.at(1408622425), cancel_at_period_end: false, subscription_id: "sub_4RYaIXR0qKYWEc")
10.times do
  Fabricate(:video, category: [sport, news, grammer].sample) do
    reviews(count: 1) {
      Fabricate(:review) {
        user [keroro, ivan, eva].sample
      }
    }
  end
end
