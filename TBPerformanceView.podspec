#
# Be sure to run `pod lib lint TBPerformanceView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TBPerformanceView'
  s.version          = '0.1.0.7'
  s.summary          = 'About iOS Performance tools '

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A collection of tools for iOS device performance persistence to detect and evaluate component development performance, device processes
                       DESC

  s.homepage         = 'https://github.com/Bintong/TBPerformanceView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'https://github.com/Bintong' => 'yaxun_123@163.com' }
  s.source           = { :git => 'https://github.com/Bintong/TBPerformanceView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TBPerformanceView/Classes/**/*'
  s.prefix_header_file = 'TBPerformanceView/Classes/PrefixHeader.pch'
  s.resource     = 'TBPerformanceView/TBPerformanceView.bundle'
#  s.resource_bundles = {
#     'TBPerformanceView' => ['TBPerformanceView/Assets/']
#  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
   s.dependency 'SDWebImage'
end
