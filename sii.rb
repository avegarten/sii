require 'sinatra'
require 'fileutils'
require 'digest'
require 'json'


# files testing automation keep this for now
testing_aut_dir = File.join(Dir.pwd, "files")
puts "testing - reset /files directory? [y/n]"
response = gets.chomp.to_s
if response == "y"
  FileUtils.rm_rf(testing_aut_dir)
  puts "done"
else
  puts "/files directory kept!"
end

#setup/start
set :bind, '0.0.0.0'
set :port, '1100'

init_files_dir = FileUtils.mkdir_p('./files').first
sii_dir = File.join(Dir.pwd, "files")


# add sqlite soon for this, but for now, just make put really nice :>
# usage is   curl -X PUT -T /home/avery/Downloads/cat.jpeg http://0.0.0.0:1100/files/images/cat.jpeg  << here actually, on sii_dest, cat.jpeg could be called anything

put '/files/*' do

  request.body.rewind

  file_splat = params['splat'].first
  stream = request.body

  sii_dest = "#{sii_dir}/#{file_splat}"
  parent_dir = File.dirname(sii_dest)

  halt 404 if stream.size == 0
  # this really needs to go somwhere else

  if File.exist?(sii_dest)
    status = status 200
  elsif !File.zero?(sii_dest) || File.file?(sii_dest)
    status = status 201
  end

  FileUtils.mkdir_p(parent_dir)
  IO::copy_stream(stream, sii_dest)

  sii_file_stat = File.stat(sii_dest)
  file_hash = Digest::SHA256.file(sii_dest).hexdigest
  uploaded_time = sii_file_stat.mtime 
  file_size = File.size(sii_dest)


  put_json = {
  'status' => status,
  'sii_dest' => sii_dest,
  'file_size' => file_size,
  'file_hash' => file_hash,
  'uploaded_time' => uploaded_time  
  }
  
  p put_json.to_json

end

