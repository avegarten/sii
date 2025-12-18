require 'sinatra'
require 'fileutils'
require 'digest'
require 'json'

#setup/start
set :bind, '0.0.0.0'
set :port, '1100'

init_files_dir = FileUtils.mkdir_p('./files').first
test_dir = '/home/avery/sii/files'
# test dir for now Dir.pwd could work?


# usage is >  curl -X PUT -T /home/avery/Downloads/cat.jpeg http://0.0.0.0:1100/files/images/cat.jpeg  <

put '/files/*' do

  request.body.rewind


  file_splat = params['splat'].first
  stream = request.body


  sii_dest = "#{test_dir}/#{file_splat}"
  parent_dir = File.dirname(sii_dest)


  halt 404 if stream.size == 0


  FileUtils.mkdir_p(parent_dir)
  IO::copy_stream(stream, sii_dest)

  hash = Digest::SHA256.file(sii_dest).hexdigest
  
put_json = {
  'hash' => hash,
  'sii_dest' => sii_dest,
  'status' => 'meow'
}
  p put_json.to_json

end

