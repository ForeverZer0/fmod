
# TODO

dir = File.join(File.dirname(__FILE__), 'core/*.rb')
Dir.glob(dir).each { |file| require file }