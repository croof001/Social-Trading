class Ckeditor::Picture < Ckeditor::Asset
  has_attached_file :data,
                    :url  => "http://localtest.me:3000/ckeditor_assets/pictures/:id/:style_:basename.:extension",
                    :path => ":rails_root/public/ckeditor_assets/pictures/:id/:style_:basename.:extension",
                    :styles => { :content => '800>', :thumb => '118x100#' }

  validates_attachment_size :data, :less_than => 2.megabytes
  validates_attachment_presence :data
  validates_attachment_content_type :data, :content_type => ['image/jpeg', 'image/jpg', 'image/png']
  def url_content
    url(:content)
  end
end
