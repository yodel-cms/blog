class UpdateBlogFieldsForAdminMigration < Migration
  def self.up(site)
    site.blogs.modify do |blogs|
      blogs.modify_field :articles_per_page, section: 'Options'
    end
    
    site.articles.modify do |articles|
      articles.modify_field :author, show_blank: true, blank_text: 'None'
    end
  end
  
  def self.down(site)
    site.blogs.modify do |blogs|
      blogs.modify_field :articles_per_page, section: nil
    end
    
    site.articles.modify do |articles|
      articles.modify_field :author, show_blank: false, blank_text: nil
    end
  end
end
