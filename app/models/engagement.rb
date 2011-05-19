class Engagement < RubyDesk::Engagement
  include ActiveModel::Validations
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  
  @@team_ref = "344625"
  attributes :id
  
  def self.all(connector)
    return self.retrieve_all(connector, @@team_ref)
  end 
  
  def self.find(connector, eng_ref)
    return self.retrieve(connector, eng_ref)
  end 
  
  def self.initialize
    super
    id = reference
  end
  
  def self.initialize(attrs = {})
    super(attrs)
    id = reference
  end
  
  # Not stored in a DB, so not persistent (for ActiveModel)
  def persisted?
    false
  end

  # TODO: Issue with id... apparently, sometimes isn't created
  def to_s
    return reference
  end
  
  def pay_bonus(connector)
    amount = '0.05' # min payment is 0.05 (0.04 to contractor, 0.01 to odesk)
    comments = 'well done!'
    notes = 'Personal notes This is a test'
    options = {
                :engagement__reference => reference, :amount => amount,
                :comments => comments, :notes => notes
              }
    begin
      RubyDesk::CustomPayment.post(connector, @@team_ref, options)
    rescue
      # fail
    end
    redirect_to(engagements_path)
  end

end
