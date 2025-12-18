require 'sinatra'
require 'fileutils'
require 'digest'
require 'json'

#setup/start

set :bind, '0.0.0.0'
set :port, '1100'

init_files_dir = FileUtils.mkdir_p('./files').first


# test dir for now
test_dir = '/home/avery/sii/files'

#upload <local_src> <sii_dest>
#usage curl -X PUT -T /home/avery/Downloads/cat.jpeg http://0.0.0.0:1100/files/images/cat.jpeg
 
put '/files/*' do
  request.body.rewind

  dir = params['splat'].first

  file = request.body

  IO::copy_stream(file, "#{test_dir}/#{dir}")
  # stream files instead File.write

  halt 404 if file.size == 0
  # basic 404 for now
end

