class EventsController < ApplicationController

  def index
    render json: ChatLog.list(from_date, to_date)
  end

  def create
    ChatLog.record(params)
    render json: { success: 'ok' }
  end

  def summary
    events = ChatLog.list(from_date, to_date)
    event_hash = Hash.new {|h,k| h[k] = []}
    events.each do |event|
      event_hash[date_at_granularity(event.date)] << event
    end
    summary_list = []
    event_hash.each do |date, date_events|
      summary_list << {'date' => date.iso8601, 'enters' => count_events(date_events, 'enter'), 'leaves' => count_events(date_events, 'leave'),
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

    def count_events(events, type)
      events.count { |x| x.type == type }
    end

    def date_at_granularity(time)
      return time.beginning_of_minute if params[:by] == 'minute'
      return time.beginning_of_hour if params[:by] == 'hour'
      return time.beginning_of_day if params[:by] == 'day'
      raise "Unknown granularity #{params[:by]}"
    end
end
