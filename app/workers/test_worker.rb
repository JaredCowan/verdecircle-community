class TestWorker
  include Sidekiq::Worker

  def perform(id, params)
    post = Post.find(id)
    post.update(subject: "#{post.subject} worker added this", body: "#{params}")
  end
end
