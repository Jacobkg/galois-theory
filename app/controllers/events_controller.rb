class EventsController < ApplicationController

  def index
    from_date = Time.parse(params[:from])
    to_date = Time.parse(params[:to])
    render json: ChatEvent.list(from_date, to_date)
  end

  def create
    ChatEvent.record(event_params)
    render json: { success: 'ok' }
  end

  private

    def event_params
      params.slice(:date, :user, :type, :message, :otheruser)
    end

end
