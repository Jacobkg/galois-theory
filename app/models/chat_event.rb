class ChatEvent

  DATABASE_FILE_NAME = '.chat_database'

  def self.record(params)
    File.open(DATABASE_FILE_NAME, 'a') do |f|
      f.puts params.to_json
    end
  end

  def self.list(from, to)
    events = File.read(DATABASE_FILE_NAME).lines.map {|x| JSON.parse(x)}
    events.select {|x| Time.parse(x['date']) >= from && Time.parse(x['date']) <= to}
  end

  def self.clear_all
    File.delete(DATABASE_FILE_NAME) if File.exist?(DATABASE_FILE_NAME)
  end

end