#!/usr/bin/rake

require 'tmpdir'

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

def build_standalone(path, deps)
  Rake::Task['bin:mkdir'].invoke
  exec_name = fn(path)
  all_deps = recursive_dependencies(deps)
  deps_files = all_deps.map { |lib| "#{LIBS_SOURCE_DIR}/#{lib}.swift" }

  Dir.mktmpdir do |dir|
    main_file = "#{dir}/main.swift"
    cleaned_source = File.read(path)
    deps.each { |lib| cleaned_source.gsub!("import #{lib}",'') }
    File.write(main_file, cleaned_source)
    `xcrun -sdk macosx swiftc -o "#{BINS_OUTPUT_DIR}/#{exec_name}" #{deps_files.join(' ')} "#{main_file}"`
    if verbose === true
      list = (deps_files + [path]).map { |d| " - #{d}" }.join("\n")
      puts "Building #{BINS_OUTPUT_DIR}/#{exec_name} from files:\n" + list
    end
  end
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

def recursive_dependencies(deps)
  all_deps = deps
  deps.each do |lib|
    inner_deps = lib_dependencies("#{LIBS_SOURCE_DIR}/#{lib}.swift")
    all_deps += recursive_dependencies(inner_deps) unless inner_deps.empty?
  end
  all_deps
end

def create_lib_task(path, deps)
  name = fn(path)
  deps_string =  deps.empty? ? "" : " (dependant on #{deps.map { |d| 'lib'+d }.join(', ')})"

  desc "Build #{name} dynamic library#{deps_string}"
  task "lib:#{name}" => deps.map { |lib| "lib:#{lib}" } do
    build_lib(path)
  end
end

def create_bin_task(path, deps = [])
  name = fn(path)
  deps_string =  deps.empty? ? "" : " (dependant on #{deps.map { |d| './lib/lib'+d+'.dylib' }.join(', ')})"

  desc "Build #{name} executable#{deps_string}"
  task "bin:#{name}" => deps.map { |lib| "lib:#{lib}" } do
    build_bin(path)
  end
end

def create_standalone_task(path, deps = [])
  name = fn(path)

  desc "Build #{name} as a standalone executable"
  task name do
    build_standalone(path, deps)
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
  create_standalone_task(path, deps)
  known_bins.push(fn(path))
end


desc 'Build all executables as standalones'
task :all => known_bins

desc 'Build all libs & bins linked against them'
task 'bin:all' => known_bins.map { |bin_name| "bin:#{bin_name}" }

desc 'clean + all'
task :default => [:clean, :all]

