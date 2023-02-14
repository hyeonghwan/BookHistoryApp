# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'BookHistoryApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BookHistoryApp
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'	
  pod 'SubviewAttachingTextView'
  pod 'OpenGraph'
  pod 'NotionSwift', '0.7.3'
end
post_install do |installer|
installer.pods_project.targets.each do |target|
if target.name == 'RxSwift'
target.build_configurations.each do |config|
if config.name == 'Debug'
config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
end
end
end
end
end



