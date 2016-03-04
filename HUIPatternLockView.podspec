Pod::Spec.new do |s|
  s.name                = "HUIPatternLockView"
  s.version             = "1.0.2"
  s.summary             = "A pattern lock view for iOS"                   
  s.homepage            = "https://github.com/Tinghui/HUIPatternLockView"
  s.license             = { :type => "MIT", :file => "LICENCE.md" }
  s.author              = { 'Tinghui' => 'tinghui.zhang3@gmail.com' }
  s.platform            = :ios, '6.0'
  s.requires_arc        = true

  s.source_files        = "HUIPatternLockView/HUIPatternLockView.{h,m}"
  s.source              = { :git => "https://github.com/Tinghui/HUIPatternLockView.git", :tag => s.version }
end
