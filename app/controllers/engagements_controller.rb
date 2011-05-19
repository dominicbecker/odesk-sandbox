class EngagementsController < ApplicationController
  before_filter :odesk_required
  
  def index
    @engagements = Engagement.all(@odesk_connector)
  end

  def show
    @engagement = Engagement.find(@odesk_connector, params[:id])
  end
  
  def bonus
    @engagement = Engagement.find(@odesk_connector, params[:id])
    @engagement.pay_bonus(@odesk_connector)
  end

end
