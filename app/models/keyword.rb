class Keyword < ActiveRecord::Base
  belongs_to :client
  has_many :tweets, :dependent => :delete_all
  
  def self.options_for_keyword_type
  [
    ['Containing given words', 'phrase'],
    ['Containing given hashtag', 'hashtag'],
    ['Reply to you', 'replay'],
    ['Mentioning someone', 'mention'],
    ['Advanced', 'advanced']
  ]
  end
  
  def self.options_for_priority
    [
    ['Lead', 1],
    ['Build followers', 2],
    ['Research', 3],
    ['Competition', 4]
    ] +
    (5..20).collect {|i| ["Others #{i}",i]}
    
  end
  
  def language
    'en'
  end
  
  def since
    nil
  end
  
  def since=(a)
    
  end
  
  def max_count
    nil
  end
end
