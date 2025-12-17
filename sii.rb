require 'sinatra'
require 'fileutils'
require 'digest'
require 'json'

#setup/start

set :bind, '0.0.0.0'
set :port, '1100'

TMPDIR = FileUtils.mkdir_p('./TMPDIR').first
ENV['TMPDIR'] = TMPDIR

init_files_dir = FileUtils.mkdir_p('./files').first


# test dir for now
test_dir = '/home/avery/sii/files'

#upload <local_src> <sii_dest>

put '/files/*' do
   request.body.rewind

  dir = params['splat'].first
  file_data = request.body.read
  
  File.write("#{test_dir}/#{dir}", file_data)



end

