#!/usr/bin/rake

LIBS_SOURCE_DIR = './SwiftGen.playground/Sources'
LIBS_OUTPUT_DIR = './lib'
BINS_SOURCE_DIR = './src'
BINS_OUTPUT_DIR = './bin'

def fn(path)
  File.basename(path, '.swift')
end

namespace :lib do
  task :mkdir do
    `[ -d "#{LIBS_OUTPUT_DIR}" ] || mkdir "#{LIBS_OUTPUT_DIR}"`
  end

  task :clean do
    `rm -rf "#{LIBS_OUTPUT_DIR}"`
  end
end

namespace :bin do
  task :mkdir do
    `[ -d "#{BINS_OUTPUT_DIR}" ] || mkdir "#{BINS_OUTPUT_DIR}"`
  end

  task :clean do
    `rm -rf "#{BINS_OUTPUT_DIR}"`
  end
end

desc 'Remove both build libraries and executables'
task :clean => %w(lib:clean bin:clean)




def build_lib(path)
  Rake::Task['lib:mkdir'].invoke
  module_name = fn(path)
  tmp_file = "#{LIBS_OUTPUT_DIR}/#{module_name}.tmp.swift"
  File.write(tmp_file, File.read(path).gsub('//@import ','import '))
  `xcrun -sdk macosx swiftc -I "#{LIBS_OUTPUT_DIR}" -L "#{LIBS_OUTPUT_DIR}" -emit-library -o "#{LIBS_OUTPUT_DIR}/lib#{module_name}.dylib" -emit-module -module-link-name "#{module_name}" "#{tmp_file}"`
  FileUtils.rm(tmp_file)
end

def build_bin(path)
  Rake::Task['bin:mkdir'].invoke
  exec_name = fn(path)
  `xcrun -sdk macosx swiftc -I "#{LIBS_OUTPUT_DIR}" -L "#{LIBS_OUTPUT_DIR}" -emit-executable -o "#{BINS_OUTPUT_DIR}/#{exec_name}" "#{path}"`
end

def lib_dependencies(path)
  content = File.read(path)
  deps = []
  content.scan(%r{^//@import (.*)$}) { |match| deps.push(match.first) }
  deps
end

def src_dependencies(path)
  content = File.read(path)
  deps = []
  content.scan(%r{^import (.*)$}) { |match| deps.push(match.first) }
  deps
end

def create_lib_task(path, deps)
  name = fn(path)
  
  desc "Build #{name} library"
  task name => deps do
    build_lib(path)
  end
end

def create_bin_task(path, deps = [])
  name = fn(path)
  
  desc "Build #{name} executable"
  task name => deps do
    build_bin(path)
  end
end




known_libs = []
Dir["#{LIBS_SOURCE_DIR}/*.swift"].each do |path|
  deps = lib_dependencies(path)
  create_lib_task(path, deps)
  known_libs.push(fn(path))
end
known_bins = []
Dir["#{BINS_SOURCE_DIR}/*.swift"].each do |path|
  libs = src_dependencies(path)
  deps = libs & known_libs
  create_bin_task(path, deps)
  known_bins.push(fn(path))
end


desc 'Build all executables'
task :all => known_bins

desc 'clean all libs & bins then regenerate all executables'
task :default => [:clean, :all]

