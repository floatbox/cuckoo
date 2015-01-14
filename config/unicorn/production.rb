# Set your full path to application.
app_dir = '/home/deployer/apps/cuckoo'
shared_dir = "#{app_dir}/shared"

# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Fill path to your app
working_directory "#{app_dir}/current"

# Set up socket location
listen "#{shared_dir}/tmp/sockets/unicorn.sock", :backlog => 64

# Loging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pidfile = "#{shared_dir}/tmp/pids/unicorn.pid"
pidfile_old = pidfile + '.oldbin'
pid pidfile

# Garbage collection
GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

#

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_dir}/current/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  if File.exists?(pidfile_old) && server.pid != pidfile_old
    begin
      Process.kill("QUIT", File.read(pidfile_old).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
