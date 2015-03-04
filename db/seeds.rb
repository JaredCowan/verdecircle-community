# Create some posts.
50.times { |i| Post.create(user_id: 3, subject: "Post Lorem #{i}", body: "this is some dummy post text.") }
