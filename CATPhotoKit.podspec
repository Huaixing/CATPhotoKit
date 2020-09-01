#
# Be sure to run `pod lib lint CATPhotoKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CATPhotoKit'
  s.version          = '0.1.2'
  s.summary          = 'kit of access local library in project.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
kit of access local library in cat project, upload appstore
                       DESC

  s.homepage         = 'https://github.com/Huaixing/CATPhotoKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Huaixing' => 'shxwork@163.com' }
  s.source           = { :git => 'https://github.com/Huaixing/CATPhotoKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'CATPhotoKit/Classes/**/*.{h, m}'
  
  # s.resource_bundles = {
  #   'CATPhotoKit' => ['CATPhotoKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
