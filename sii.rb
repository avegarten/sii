require 'sinatra'
require 'fileutils'
require 'digest'
require 'json'


#setup/start
set :bind, '0.0.0.0'
set :port, '1100'

init_files_dir = FileUtils.mkdir_p('./files').first
sii_dir = File.join(Dir.pwd, "files")

# usage is >  curl -X PUT -T /home/avery/Downloads/cat.jpeg http://0.0.0.0:1100/files/images/cat.jpeg  <

put '/files/*' do

  request.body.rewind

  file_splat = params['splat'].first
  stream = request.body

  sii_dest = "#{sii_dir}/#{file_splat}"
  parent_dir = File.dirname(sii_dest)

  halt 404 if stream.size == 0

  FileUtils.mkdir_p(parent_dir)
  IO::copy_stream(stream, sii_dest)

  sii_file_stat = File.stat(sii_dest)
  file_hash = Digest::SHA256.file(sii_dest).hexdigest
  uploaded_time = sii_file_stat.mtime 
  file_size = File.size(sii_dest)
  
  # replace 'status' => 'meow' with actual status codes, ie 201 file created but im too tired and ill go bed instead of doing that
put_json = {
  'status' => 'meow',
  'sii_dest' => sii_dest,
  'file_size' => file_size,
  'hash' => file_hash,
  'uploaded_time' => uploaded_time
}
  p put_json.to_json
end
