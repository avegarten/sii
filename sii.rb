require 'sinatra'
require 'fileutils'
require 'digest'
require 'json'

#setup/start

# please rename these variables please avery

set :bind, '0.0.0.0'
set :port, '1100'

init_files_dir = FileUtils.mkdir_p('./files').first


# test dir for now
test_dir = '/home/avery/sii/files'


put '/files/*' do

  request.body.rewind

  file_path = params['splat'].first
  stream = request.body

  sii_dest = "#{test_dir}/#{file_path}"
  parent_dir = File.dirname(sii_dest)

  puts sii_dest
  puts parent_dir
  # for now, testing paths to see whats coming
  # /home/avery/sii/files/images/cat.jpeg
  # /home/avery/sii/files/images



  halt 404 if stream.size == 0
  # basic 404 for now

  FileUtils.mkdir_p(parent_dir)
  IO::copy_stream(stream, sii_dest)

end
