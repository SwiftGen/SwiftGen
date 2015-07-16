#!/usr/bin/rake

MODULES_SOURCE_DIR = './src'
MODULES_BUILT_DIR = './lib'

task :mkdir do
  `[ -d "#{MODULES_BUILT_DIR}" ] || mkdir "#{MODULES_BUILT_DIR}"`
end

desc "Remove all build products in #{MODULES_BUILT_DIR}"
task :clean do
  `rm -rf "#{MODULES_BUILT_DIR}"`
end

desc "Generate all libraries and modules from source"
task :build => :mkdir do
  Dir["#{MODULES_SOURCE_DIR}/*.swift"].each do |path|
    build_module File.basename(path, '.swift')
  end
end


desc 'clean and regenerate all libs and  modules from source'
task :default => [:clean, :build]

def build_module(name)
  `xcrun -sdk macosx swiftc -emit-library -o "#{MODULES_BUILT_DIR}/lib#{name}.dylib" -emit-module -module-link-name "#{name}" #{MODULES_SOURCE_DIR}/"#{name}.swift"`
end
