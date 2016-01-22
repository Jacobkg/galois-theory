class EventsController < ApplicationController

  def index
    render json: ChatLog.list(from_date, to_date)
  end

  def create
    event = ChatEvent.new(params)
    ChatLog.record!(event)
    render json: { success: 'ok' }
  end

  def summary
    events = ChatLog.list(from_date, to_date)
    render json: ChatSummary.new(events).summarize_by(params[:by])
  end

  private

    def from_date
      params[:from].to_time
    end

    def to_date
      params[:to].to_time
    end
end
