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

  dir = params['splat'].first
  file = request.body

  final_dir = "#{test_dir}/#{dir}"
  init_path = File.dirname(final_dir)

  puts final_dir
  puts init_path
  # for now, testing paths to see whats its giving

  halt 404 if file.size == 0
  # basic 404 for now

  FileUtils.mkdir_p(init_path)
  IO::copy_stream(file, final_dir)

end
