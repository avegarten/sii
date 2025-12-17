require 'sinatra'
require 'fileutils'
require 'digest'
require 'json'

#setup/start

set :bind, '0.0.0.0'
set :port, '1100'

TMPDIR = FileUtils.mkdir_p('./TMPDIR').first
ENV['TMPDIR'] = TMPDIR

files_dir = FileUtils.mkdir_p('./files').first






#upload <local_src> <sii_dest>
put '/' do
end