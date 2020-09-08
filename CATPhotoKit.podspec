Pod::Spec.new do |s|
  s.name             = "CATPhotoKit"
  s.version          = "0.1.3"
  s.summary          = "kit of access local library in project."
  s.description      = <<-DESC
kit of access local library in cat project, upload appstore
                       DESC

  s.homepage         = "https://github.com/Huaixing/CATPhotoKit"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Huaixing" => "shxwork@163.com" }
  s.source           = { :git => "https://github.com/Huaixing/CATPhotoKit.git", :tag => s.version.to_s }

  s.ios.deployment_target = "10.0"

  s.source_files = "CATPhotoKit/Classes/**/*.{h,m}"
  
  s.resource_bundles = {
    'CATPhotoKit' => ['CATPhotoKit/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
