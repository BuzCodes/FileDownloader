#
# Be sure to run `pod lib lint FileDownloader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FileDownloader'
  s.version          = '0.1.0'
  s.summary          = 'A simple yet highly customizable Downloader with File Handling power!'
  s.description      = <<-DESC
  A simple yet highly customizable Downloader with File Handling power!
  You can use both closures and Combine to easily start a download.
                       DESC

  s.homepage         = 'https://github.com/HolyBuz/FileDownloader'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alessandro Loi' => 'holybuz@gmail.com' }
  s.source           = { :git => 'https://github.com/HolyBuz/FileDownloader.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.source_files = 'Classes/**/*.{swift, h, m}'
  s.frameworks = 'UIKit', 'Combine', 'Foundation'
end
