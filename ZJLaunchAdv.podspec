Pod::Spec.new do |s|
  s.name         = "ZJLaunchAdv"
  s.version      = "1.0.0"
  s.summary      = "easy to add launchAdv"
  s.homepage     = "https://github.com/DreamerZJ/ZJLaunchAdv.git"
  s.license      = "MIT"
  s.authors      = { 'zhangjian' => '1154467706@qq.com'}
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/DreamerZJ/ZJLaunchAdv.git", :tag => s.version }
  s.source_files = 'ZJLaunchAdv', 'ZJLaunchAdv/**/*.{h,m}'
  s.requires_arc = true
  s.dependency 'SDWebImage', '~> 4.2.2'
  s.dependency 'SDWebImage/GIF', '~> 4.2.2'
end
