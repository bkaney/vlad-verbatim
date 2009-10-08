require 'erb'
require 'yaml'
require 'vlad'

module Vlad::Verbatim

  unless const_defined? "TEMPLATE_PATH"
    TEMPLATE_PATH = "./config/target"
  end

  def front_matter(contents)
    YAML::load(contents) if contents =~ /^---\n/
  end

  def set_file_mode(remote_filename, mode=nil)
    run "chmod #{mode} #{remote_filename}" unless mode.nil?
  end

  def set_file_owner(remote_filename, owner=nil)
    run "chown #{owner} #{remote_filename}" unless owner.nil?
  end

  def check(args={})
    rebuild_or_verify(:dry_run => true, :verbose => args[:verbose])
  end

  def verbatimize!
    rebuild_or_verify(:dry_run => false)
  end

  def rebuild_or_verify(args={})
    Dir.glob("#{TEMPLATE_PATH}/**/*.erb").each do |template_file|
      template = File.readlines(template_file).map {|l| l.rstrip}.join "\n"
      target_filename = template_file.gsub /\.erb$/, ''; target_filename.gsub! /^.*\/#{TEMPLATE_PATH}\//, "/"
      fm = front_matter(template)
      
      if args[:dry_run] == true
          out = ERB.new(template).result(binding)
          puts " * #{template_file} with #{fm.inspect}"
          puts out if args[:verbose]

      else
        put target_filename do
          ERB.new(template).result(binding)
        end

        set_file_owner(target_filename, fm['owner'])
        set_file_mode(target_filename, fm['mode'])
      end
    end 
  end

end

namespace :vlad do
    
  desc "Sync's up the remote configuration"
  task :verbatim do
    Vlad::Verbatim.verbatimize!
  end

  namespace :verbatim do
    
    desc "Tests target templates for compilation errors"
    task :check do
      Vlad::Verbatim.check
    end

    task :check_verbose do
      Vlad::Verbatim.check(:verbose => true)
    end

  end

end

