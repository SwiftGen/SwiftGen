#!/usr/bin/rake

MODULES_SOURCE_DIR = './SwiftGen.playground/Sources'
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
  # Dir["#{MODULES_SOURCE_DIR}/*.swift"].each do |path|
  build_module("#{MODULES_SOURCE_DIR}/SwiftIdentifier.swift")
  build_module("#{MODULES_SOURCE_DIR}/SwiftGenAssetsEnumFactory.swift")
  # end
end


desc 'clean and regenerate all libs and  modules from source'
task :default => [:clean, :build]

def build_module(file_path)
  module_name = File.basename(file_path, '.swift')
  tmp_file = "#{MODULES_BUILT_DIR}/#{module_name}.tmp.swift"
  File.write(tmp_file, File.read(file_path).gsub('//@import ','import '))
  `xcrun -sdk macosx swiftc -I "#{MODULES_BUILT_DIR}" -L "#{MODULES_BUILT_DIR}" -emit-library -o "#{MODULES_BUILT_DIR}/lib#{module_name}.dylib" -emit-module -module-link-name "#{module_name}" "#{tmp_file}"`
  FileUtils.rm(tmp_file)
end
