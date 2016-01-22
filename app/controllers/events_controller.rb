class EventsController < ApplicationController

  def index
    render json: ChatEvent.list(from_date, to_date)
  end

  def create
    ChatEvent.record(event_params)
    render json: { success: 'ok' }
  end

  def summary
    events = ChatEvent.list(from_date, to_date)
    event_hash = Hash.new {|h,k| h[k] = []}
    events.each do |event|
      event_hash[date_at_granularity(event['date'])] << event
    end
    summary_list = []
    event_hash.each do |date, date_events|
      summary_list << {'date' => date, 'enters' => count_events(date_events, 'enter'), 'leaves' => count_events(date_events, 'leave'),
                       'comments' => count_events(date_events, 'comment'), 'highfives' => count_events(date_events, 'highfive') }
    end
    render json: summary_list
  end

  private

    def from_date
      params[:from].to_time
    end

    def to_date
      params[:to].to_time
    end

    def event_params
      params.slice(:date, :user, :type, :message, :otheruser)
    end

    def count_events(events, type)
      events.count { |x| x["type"] == type }
    end

    def date_at_granularity(time_string)
      time = time_string.to_time.utc
      time = time.beginning_of_minute if params[:by] == 'minute'
      time = time.beginning_of_hour if params[:by] == 'hour'
      time = time.beginning_of_day if params[:by] == 'day'
      return time.iso8601
    end
end
