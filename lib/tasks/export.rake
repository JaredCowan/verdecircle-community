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

  desc "Create users."
  task :create_users => :environment do

    30.times do |n|
      User.create(
        id: User.last.id + 1,
        first_name: FFaker::Name.first_name,
        last_name: FFaker::Name.last_name,
        email: FFaker::Internet.safe_email,
        username: FFaker::Internet.user_name("#{FFaker::Name.first_name}#{FFaker::Lorem.words(1).sort[0]} #{FFaker::Name.last_name}").gsub(/[._]/, "")[0, 15],
        password: "$2a$06$CRFCw90N9pTm5uQ3xD1HR.s8.dTCPHprlHquIDDKQn8UZLl8rIpkC",
        is_admin: false,
        created_at: Time.now.to_s.split("+")[0].strip
      )
    end
  end

  desc "Create posts, with comments and replies."
  task :create_posts => :environment do

    postAry, cmntAry = [], []
    70.times do |n|
      Post.create(
        user_id: User.all.map(&:id).sample,
        subject: FFaker::Lorem.words(4).join(' '),
        body: FFaker::Lorem.paragraph(7),
        topic_id: Topic.all.map(&:id).sample,
        tag_list: FFaker::Lorem.words(5).join(', ')
      )
      postAry.push(Post.first.id)
    end

    postAry[0, 11].each do |pa|
      10.times do |c|
        Comment.create(
          body: FFaker::Lorem.paragraph(7),
          user_id: User.all.map(&:id).sample,
          post_id: pa,
        )
        cmntAry.push(Comment.last.id)
      end
    end

    cmntAry.each do |r|
      10.times do |cr|
        Reply.create(
          body: FFaker::Lorem.paragraph(7),
          user_id: User.all.map(&:id).sample,
          comment_id: r,
        )
      end
    end
  end
end
