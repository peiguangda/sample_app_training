users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow followed }
followers.each { |follower| follower.follow user }