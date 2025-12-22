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


# curl -X PUT -T '/home/avery/Downloads/Claude_Monet_022.jpg'   http://0.0.0.0:1100/files/images/
put "/files/*" do

request.body.rewind

file_splat = params['splat'].first
stream = request.body

sii_final = "#{sii_dir}/#{file_splat}"
sii_parent = File.dirname(sii_final)

p "file_splat: #{file_splat}"
p "sii_final: #{sii_final}"
p "sii_parent: #{sii_parent}"

if stream.size == 0
  halt 400
  status = 400
end

if File.exist?(sii_final)
  status = 200
elsif Dir.exist?(sii_parent)
  status = 201
  IO::copy_stream(stream, sii_final)
else
  status = 400
  halt 400
end

sii_file_stat = File.stat(sii_final)
file_hash = Digest::SHA256.file(sii_final).hexdigest
uploaded_time = sii_file_stat.mtime
file_size = File.size(sii_final)

puts_json = {
  'status' => status,
  'sii_final' => sii_final,
  'file_size' => file_size,
  'file_hash' => file_hash,
  'uploaded_time' => uploaded_time
}

p puts_json.to_json
end

# req to create a folder and directory 
# curl -X POST http://0.0.0.0:1100/files/images/arts/
post '/files/*' do
  request.body.rewind

  post_splat = params['splat'].first
  created_dir = File.join(sii_dir, post_splat)

  p "created dir = #{created_dir}"
  p "post_splat = #{post_splat}"
  p "created_dir = #{created_dir}"

 if Dir.exist?(created_dir) || !post_splat.end_with?("/") 
    status = 409
    # halt 409
 elsif post_splat.end_with?("/")
  FileUtils.mkdir_p(created_dir)
  status = 201
  created_dir_stat = File.stat(created_dir)
  created_time = created_dir_stat.mtime
  sii_dest = created_dir if Dir.exist?(created_dir)
  end

  post_mkdir_json = {
  'status' => status,
  'sii_dest' => sii_dest,
  'created_time' => created_time
  }

  p post_mkdir_json.to_json.to_s
end
