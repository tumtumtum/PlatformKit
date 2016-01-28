Pod::Spec.new do |s|
  s.name         = "PlatformKit"
  s.version      = "0.2.0"
  s.summary      = "A set of useful classes and extensions for modern Objective C"
  s.homepage     = "https://github.com/tumtumtum/PlatformKit/"
  s.license      = 'MIT'
  s.author       = { "Thong Nguyen" => "tumtumtum@gmail.com" }
  s.source       = { :git => "https://github.com/tumtumtum/PlatformKit.git", :tag => s.version.to_s}
  s.platform     = :ios
  s.requires_arc = true
  s.library = 'z'
  s.source_files = 'PlatformKit/PlatformKit/**/*.{h,m}'
  s.ios.deployment_target = '5.1'
  s.ios.frameworks   = 'CoreFoundation'
  s.osx.deployment_target = '10.7'
  s.osx.frameworks = 'CoreFoundation'
  s.watchos.deployment_target = '2.0'
  s.watchos.frameworks   = 'CoreFoundation'

  s.subspec 'Core' do |sp|
	sp.source_files = 'PlatformKit/PlatformKit/Core/**/*.{h,m}'
  end

  s.subspec 'Network' do |sp|
	sp.source_files = ['PlatformKit/PlatformKit/Network/**/*.{h,m}', 'PlatformKit/PlatformKit/Core/**/*.{h,m}']
  end

  s.subspec 'UI' do |sp|
	sp.source_files = ['PlatformKit/PlatformKit/UI/**/*.{h,m}', 'PlatformKit/PlatformKit/Core/**/*.{h,m}']
  end

end
