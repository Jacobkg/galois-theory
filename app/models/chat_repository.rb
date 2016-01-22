class ChatRepository

  DATABASE_FILE_NAME = '.chat_database'

  def self.save!(event)
    File.open(DATABASE_FILE_NAME, 'a') do |f|
      f.puts event.to_json
    end
  end

  def self.search(from_date, to_date)
    event_params_list = File.read(DATABASE_FILE_NAME).lines.map {|x| JSON.parse(x)}
    event_params_list.map {|x| ChatEvent.new(x) }
  end

  def self.destroy_all
    File.delete(DATABASE_FILE_NAME) if File.exist?(DATABASE_FILE_NAME)
  end

end