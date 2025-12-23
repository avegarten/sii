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
sii_dir = File.join(Dir.pwd ,"files")


# req to upload a file 
# curl -X PUT -T '/home/avery/Downloads/claude_monet.jpg'   http://0.0.0.0:1100/files/images/

# still creates an file if the curl requests ends without a trailing "/" 
# if called the current directory it is put in, please make sure this is fixed or realized in the client?
put '/files/*' do
  request.body.rewind

  file_splat = params['splat'].first
  stream = request.body

  sii_final = File.join(sii_dir, file_splat)
  sii_parent = File.dirname(sii_final)

  if stream.size == 0
    halt 400
    status = 400
  end

  if File.exist?(sii_final)
    status = 200

  elsif Dir.exist?(sii_parent)
    status = 201
    IO::copy_stream(stream, sii_final)

    sii_file_stat = File.stat(sii_final)
    file_hash = Digest::SHA256.file(sii_final).hexdigest
    uploaded_time = sii_file_stat.mtime
    file_size = File.size(sii_final)

  else
    status = 400
    halt 400, {status: 400, sii_final: nil, file_size: nil, file_hash: nil, uploaded_time: nil}.to_json
  end

  p puts_json = {status: status, sii_final: sii_final, file_size: file_size, file_hash: file_hash, uploaded_time: uploaded_time}.to_json
end

# req to create a folder and directory 
# curl -X POST http://0.0.0.0:1100/files/images/arts/
post '/files/*' do
  request.body.rewind

  post_splat = params['splat'].first
  created_dir = File.join(sii_dir, post_splat)
 
  if !post_splat.end_with?("/")    
    status = 400
    halt 400, {status: status, sii_dest: nil, created_time: nil}.to_json
  end

  if Dir.exist?(created_dir)
    status = 409

  elsif post_splat.end_with?("/")
    FileUtils.mkdir_p(created_dir)
    status = 201
    created_dir_stat = File.stat(created_dir)
    created_time = created_dir_stat.mtime
    sii_dest = created_dir if Dir.exist?(created_dir)
  end

  p post_mkdir_json = {status: status, sii_dest: sii_dest, created_time: created_time}.to_json
end

# req to delete a file or folder 
# curl -X DELETE http://0.0.0.0:1100/files/*
delete '/files/*' do
  request.body.rewind

  delete_splat = params['splat'].first
  delete_path = File.join(sii_dir, delete_splat)

  if delete_splat.empty?
    puts "empty"
    status = 403

  elsif File.exist?(delete_path) || Dir.exist?(delete_path)
    FileUtils.rm_rf(delete_path)
    status = 200

  else
    status = 404
  end

  p delete_json = {status: status, delete_path: delete_path}.to_json
end

# req to get a file 
# curl -f -J -O http://0.0.0.0:1100/files/* saves to current cd
get '/files/*' do
  request.body.rewind
  
  get_splat = params['splat'].first
  get_final = File.join(sii_dir, get_splat)

  if File.exist?(get_final)
    send_file get_final
  else
    halt 404
  end
end




