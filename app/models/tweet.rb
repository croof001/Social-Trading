class Tweet < ActiveRecord::Base
  belongs_to :client
  belongs_to :keyword
  
   filterrific(
    :default_settings => { :sorted_by => 'posted_at_desc' },
    :filter_names => [
      :sorted_by,
      :search_query,
      :with_keyword_id,
      :with_created_at_gte,
      :with_author,
      :with_priority
    ]
  )
  
def self.options_for_sorted_by
  [
    ['Time (newest first)', 'posted_at_desc'],
    ['Keyword', 'keyword_asc'],
    ['Time (oldest first)', 'posted_at_asc'],
    ['Author', 'author_asc'],
    ['Priority','priority_asc']
  ]
end

def self.options_for_batch_action
  [
    ['Mark as read', 'mark'],
    ['Delete', 'delete'],
    ['retweet', 'created_at_asc'],
    ['follow', 'author_asc']
  ]
end

  scope :with_keyword_id, lambda { |keyword_ids|
    # Filters students with any of the given country_ids
     keyword_ids.delete("")
     where(:keyword_id => [*keyword_ids])
  }
  
  scope :with_priority, lambda { |priority_ids|
    # Filters students with any of the given country_ids
    
     where('keywords.priority' => [*priority_ids])
  }
  
  scope :with_created_at_gte, lambda { |reference_time|
  where('tweets.posted_at >= ?', reference_time.to_datetime)
  }
  
  scope :search_query, lambda { |query|
  # Searches the students table on the 'first_name' and 'last_name' columns.
  # Matches using LIKE, automatically appends '%' to each term.
  # LIKE is case INsensitive with MySQL, however it is case
  # sensitive with PostGreSQL. To make it work in both worlds,
  # we downcase everything.
  return nil  if query.blank?

  # condition query, parse into individual keywords
  terms = query.downcase.split(/\s+/)

  # replace "*" with "%" for wildcard searches,
  # append '%', remove duplicate '%'s
  terms = terms.map { |e|
    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
  }
  # configure number of OR conditions for provision
  # of interpolation arguments. Adjust this if you
  # change the number of OR conditions.
  num_or_conds = 1
  where(
    terms.map { |term|
      "(LOWER(tweets.message) LIKE ? )"
    }.join(' AND '),
    *terms.map { |e| [e] * num_or_conds }.flatten
  )
}

  
  scope :sorted_by, lambda { |sort_option|
  # extract the sort direction from the param value.
  direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
  case sort_option.to_s
  when /^posted_at_/
    # Simple sort on the created_at column.
    # Make sure to include the table name to avoid ambiguous column names.
    # Joining on other tables is quite common in Filterrific, and almost
    # every ActiveRecord table has a 'created_at' column.
    order("tweets.posted_at #{ direction }")
  when /^author_/
    # Simple sort on the name colums
    order("LOWER(tweets.author) #{ direction }")
  when /^keyword_/
    # This sorts by a student's country name, so we need to include
    # the country. We can't use JOIN since not all students might have
    # a country.
    order("LOWER(keywords.nickname) #{ direction }").includes(:keyword)
    
  when /^priority_/
    # Simple sort on the created_at column.
    # Make sure to include the table name to avoid ambiguous column names.
    # Joining on other tables is quite common in Filterrific, and almost
    # every ActiveRecord table has a 'created_at' column.
    order("keywords.priority #{ direction }").includes(:keyword)
  else
    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
  end
}

scope :with_author, lambda { |query|
  # Searches the students table on the 'first_name' and 'last_name' columns.
  # Matches using LIKE, automatically appends '%' to each term.
  # LIKE is case INsensitive with MySQL, however it is case
  # sensitive with PostGreSQL. To make it work in both worlds,
  # we downcase everything.
  return nil  if query.blank?

  # condition query, parse into individual keywords
  terms = query.downcase.split(/\s+/)

  # replace "*" with "%" for wildcard searches,
  # append '%', remove duplicate '%'s
  terms = terms.map { |e|
    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
  }
  # configure number of OR conditions for provision
  # of interpolation arguments. Adjust this if you
  # change the number of OR conditions.
  num_or_conds = 1
  where(
    terms.map { |term|
      "(LOWER(tweets.author) LIKE ? )"
    }.join(' AND '),
    *terms.map { |e| [e] * num_or_conds }.flatten
  )
}
  
end
