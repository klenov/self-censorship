require 'yaml'
require 'erb'
require 'logger'
require 'pry'


PASSWORDS_FILE_NAME = '.passwords.yml.erb'

$logger = Logger.new(STDOUT)
$logger.level = Logger::INFO

class FileWithPasswords

  def initialize(params)
    @path = params[:path]
    @passwords_pairs = params[:passwords_pairs]
    @replaced_passwords_count = 0
    read_file
  end

  def replace_fake_passwords!
    if @file_as_string
      @passwords_pairs.each do |password_pair|
        replace_fake_password(password_pair['fake_data'], password_pair['real_data'])
      end

      write_file
    end
  end

private

  def read_file
    #binding.pry
    if File.file?(@path)
      @file_as_string = File.read(@path)
      $logger.debug("#{@path} file loaded.")
    else
      $logger.error("File #{@path} doesn't exist.")
    end
  end

  def write_file
    if @replaced_passwords_count > 0
      File.open(@path, 'w') {|file| file.puts @file_as_string }
      $logger.info("Writing to file #{@path}. #{@replaced_passwords_count} fake passwords replaced.")
    else
      $logger.warn("File #{@path} not changed so no update needed.")
    end
  end

  def print_empty_warning
  end

  def replace_fake_password(fake_data, real_data)
    raise "Empty fake password in file #{@path}" if fake_data.nil? || fake_data.empty?
    raise "Empty real password in file #{@path}" if real_data.nil? || real_data.empty?

    if @file_as_string.gsub!(fake_data, real_data)
      @replaced_passwords_count += 1
      $logger.debug("Found fake string '#{fake_data}'.")
    else
      $logger.warn("Can't find fake string '#{fake_data}' in file #{@path}. Already raplaced?")
    end
  end

end


def load_files_and_passwords_hash
  YAML.load(ERB.new(File.new(PASSWORDS_FILE_NAME).read).result)
end


begin
  #binding.pry
  load_files_and_passwords_hash.each do |hash|
    file = FileWithPasswords.new(path: hash['path'], passwords_pairs: hash['passwords'])
    file.replace_fake_passwords!
  end
rescue => exception
  $logger.fatal "Caught exception: #{exception.message}. Exiting."
  $logger.fatal exception.backtrace
  raise
ensure
  $logger.close
end
