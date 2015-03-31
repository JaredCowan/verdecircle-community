# rake export:method_name_here
namespace :export do

  desc "Creates the seed data for Category names."
  task :categories => :environment do
    puts "** Creating category names. **"

    I18n.t("category_names").each do |key, category|
      Topic.find_or_create_by!(name: "#{category.parameterize}")
    end
  end
end
