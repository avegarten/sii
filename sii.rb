require 'sinatra'
require 'fileutils'
require 'digest'
require 'json'

#setup/start
set :bind, '0.0.0.0'
set :port, '1100'

init_files_dir = FileUtils.mkdir_p('./files').first
test_dir = '/home/avery/sii/files'
# test dir for now


# usage is >  curl -X PUT -T /home/avery/Downloads/cat.jpeg http://0.0.0.0:1100/files/images/cat.jpeg  <

put '/files/*' do

  request.body.rewind

  file_path = params['splat'].first
  stream = request.body

  sii_dest = "#{test_dir}/#{file_path}"
  parent_dir = File.dirname(sii_dest)
  # here, sii_dest is the actual file

  puts Digest::SHA256.file(sii_dest).hexdigest
  puts sii_dest
  puts parent_dir
  # for now, testing to see whats coming

  halt 404 if stream.size == 0
  # basic 404 for now

  FileUtils.mkdir_p(parent_dir)
  IO::copy_stream(stream, sii_dest)

put_json = '{
  "is_claimed":true,
  "rating":3.5,
  "mobile_url":"http://m.yelp.com/biz/rudys-barbershop-seattle"
}'
  put_json_result = JSON.parse(put_json)
  p put_json_result.to_json
# we will fix this soon but i am going to bed instead

end
