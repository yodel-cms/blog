class BlogModelMigration < Migration
  def self.up(site)
    site.pages.create_model :blogs do |blogs|
      add_field :articles_per_page, :integer, default: 5
      add_field :blog, :self
      blogs.record_class_name = 'Blog'
    end
  end
  
  def self.down(site)
    site.blogs.destroy
  end
end
