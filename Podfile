platform :ios, '13.0'
inhibit_all_warnings!
use_frameworks!
install! 'cocoapods', generate_multiple_pod_projects: true, incremental_installation: true

project 'TuistRootManifestFileExample.xcodeproj'

target 'TuistRootManifestFileExample' do

  # Cocoapods -> Tuist migration: used to download the 'Project.swift' file
  pod 'TuistExampleLoggingLibrary', git: 'https://github.com/Buju77/TuistExampleLoggingLibrary.git', branch: 'main'

  target 'UnitTests' do
  end
end
