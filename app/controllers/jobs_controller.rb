class JobsController < ApplicationController
  before_filter :odesk_required
  
  # GET /jobs
  def index
    @jobs = Job.all(@odesk_connector)
  end

  # GET /jobs/1
  def show
    @job = Job.find(@odesk_connector, params[:id])
    @offers = @job.get_offers(@odesk_connector, params[:id])
  end

  def new
    @team_options = []
    @roles = RubyDesk::UserRole.get_userroles(@odesk_connector)
    @roles.each do |role| # check perms later
      @team_options << [role.team__name, role.team__reference]
    end
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
    @team_options = []
    @roles = RubyDesk::UserRole.get_userroles(@odesk_connector)
    @roles.each do |role| # check perms later
      @team_options << [role.team__name, role.team__reference]
    end
    
    @job = Job.find(@odesk_connector, params[:id])
    # TODO: tmp fix, don't know how the integer rep of date from odesk works
    @job.start_date = nil
    @job.end_date = nil
  end

  # POST jobs
  def create
    fix_form_dates(params)
    
    @job = Job.new(params[:job])
    begin
        @job.post(@odesk_connector)
    rescue
        # bad request
    end
#    respond_to do |format|
      # if post successful, show success message
      # else, show errors
#    end
  end

  # PUT /jobs/1
  def update
    fix_form_dates(params)
#    @job = Job.find(@odesk_connector, params[:id])
    @job = Job.new(params[:job])
    begin
      @job.update(@odesk_connector)
    rescue
      # bad request
    end
      
    
#    respond_to do |format|
      # if update successful, say success
      # else, say errors
#    end
  end

  # DELETE jobs/1
  def destroy
    begin
      Job.cancel!(@odesk_connector, params[:id], ACCIDENTAL_OPENING_CREATION)
    rescue
      # forbidden; i.e. already cancelled or don't have permission to cancel
    end
    redirect_to(jobs_url)
  end
  
  # expects a params hash as we use in edit and create
  def fix_form_dates(params)
    year,month,day =  params[:job]["start_date(1i)"],
                      params[:job]["start_date(2i)"],
                      params[:job]["start_date(3i)"]
    date = month + '-' + day + '-' + year
    1.upto(3) {|x| params[:job].delete("start_date(#{x}i)")}
    params[:job].store(:start_date, date)
    
    y,m,d          =  params[:job]["end_date(1i)"],
                      params[:job]["end_date(2i)"],
                      params[:job]["end_date(3i)"]
    date_e = m + '-' + d + '-' + y
    1.upto(3) {|x| params[:job].delete("end_date(#{x}i)")}
    params[:job].store(:end_date, date_e)
  end
  
end
