Pod::Spec.new do |s|
  s.name         = "PlatformKit"
  s.version      = "0.1.1"
  s.summary      = "A set of useful classes and extensions for modern Objective C"
  s.homepage     = "https://github.com/tumtumtum/PlatformKit/"
  s.license      = 'MIT'
  s.author       = { "Thong Nguyen" => "tumtumtum@gmail.com" }
  s.source       = { :git => "https://github.com/tumtumtum/PlatformKit.git", :tag => s.version.to_s}
  s.platform     = :ios
  s.requires_arc = true
  s.library = z
  s.source_files = 'PlatformKit/PlatformKit/**/*.{h,m}'
  s.ios.deployment_target = '5.1'
  s.ios.frameworks   = 'CoreFoundation'
end
