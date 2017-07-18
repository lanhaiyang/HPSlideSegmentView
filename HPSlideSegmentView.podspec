#
#  Be sure to run `pod spec lint HPSlideSegmentView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "HPSlideSegmentView"
  s.version      = "0.0.1"
  s.summary      = "HPSlideSegmentView 滑动悬停和侧滑框架"


  s.homepage     = "https://github.com/lanhaiyang/HPSlideSegmentView"


  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author       = { "lanhaiyang" => "1002230810@qq.com" }


  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/lanhaiyang/HPSlideSegmentView.git", :tag => s.version.to_s }



  s.source_files  = "HPSlideSegmentView/HPSlideSegmenView/**/*.{h,m}"


  s.requires_arc = true

end
