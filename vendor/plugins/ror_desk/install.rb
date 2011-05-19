require 'fileutils'

src = File.join(File.dirname(__FILE__), 'config', 'odesk.yml')
target = File.join(Rails.root, 'config', 'odesk.yml')
FileUtils.cp src, target unless File.exists?(target)

# Add line to Gemfile if there is a Gemfile to require ruby_desk
#gfname = File.join(Rails.root, 'Gemfile')
#if File.exists(gfname)
#  gf = File.open(gfname, 'a')
#  gf.puts("\ngem \'ruby_desk\'")
#  gf.close
#end
