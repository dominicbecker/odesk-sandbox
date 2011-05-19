class Job < RubyDesk::HRJob
  include ActiveModel::Validations
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  
  @@team_ref = "344625"
  attributes :id
  
  def self.all(connector)
    return self.retrieve_all(connector, @@team_ref)
  end 
  
  def self.find(connector, job_ref)
    return self.retrieve(connector, job_ref)
  end 
  
  def self.initialize
    super
    id = reference
  end
  
  def self.initialize(attrs = {})
    super(attrs)
    id = reference
  end
  
  def get_offers(connector, jid)
    return Offer.retrieve_all(connector, @@team_ref, {:job__reference => jid})
  end
  
  def self.cancel!(connector, jid, reason)
    response = Job.cancel(connector, jid, reason)
    return response
  end
  
  def post(connector)
    options = {:job_data => {
                  :title => title,
                  :job_type => job_type,
                  :description => description,
                  :end_date => end_date,
                  :buyer_team__reference => buyer_team__reference,
                  :visibility => visibility,
                  :category => category,
                  :subcategory => subcategory
                  }
                  }
    
    if job_type == 'fixed-price'
      options[:job_data][:budget] = budget
    else
      options[:job_data][:duration] = duration
    end
    
    res = Job.post(connector, options)
  end
  
  # Not stored in a DB, so not persistent (for ActiveModel)
  def persisted?
    false
  end

  # TODO: Issue with id... apparently, sometimes isn't created
  def to_s
    return reference
  end

end
