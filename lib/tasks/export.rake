# rake export:method_name_here
namespace :export do

  desc "Creates the seed data for Category names."
  task :categories => :environment do
    puts "** Creating category names. **"

    I18n.t("category_names").each do |key, category|
      Topic.find_or_create_by!(name: "#{category.parameterize}")
    end
  end

  desc "Delete images from posts."
  task :remove_images => :environment do

    Post.all.each do |p|
      p.image_delete = "1"
      p.save
      p.image.destroy
    end
  end

  desc "Create posts."
  task :create_posts => :environment do

    postAry, cmntAry = [], []
    10.times do |n|
      Post.create(
        user_id: User.all.map(&:id).sample,
        subject: Faker::Lorem.words(4).join(', '),
        body: Faker::Lorem.paragraph(7),
        topic_id: Topic.all.map(&:id).sample,
        tag_list: Faker::Lorem.words(5).join(', ')
      )
      postAry.push(Post.first.id)
    end

    postAry.each do |pa|
      10.times do |c|
        Comment.create(
          body: Faker::Lorem.paragraph(7),
          user_id: User.all.map(&:id).sample,
          post_id: pa,
        )
        cmntAry.push(Comment.last.id)
      end
    end

    cmntAry.each do |r|
      10.times do |cr|
        Reply.create(
          body: Faker::Lorem.paragraph(7),
          user_id: User.all.map(&:id).sample,
          comment_id: r,
        )
      end
    end
  end
end
