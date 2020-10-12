#
#  Be sure to run `pod spec lint RefreshControlKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name          = "RefreshControlKit"
  spec.version       = "0.0.3"
  spec.summary       = "RefreshControlKit is a library for custom RefreshControl that can be used like UIRefreshControl"
  spec.homepage      = "https://github.com/hirotakan/RefreshControlKit"
  spec.license       = { :type => "MIT", :file => "LICENSE" }
  spec.author        = "hirotakan"
  spec.platform      = :ios, "12.0"
  spec.swift_version = "5.0"
  spec.source        = { :git => "https://github.com/hirotakan/RefreshControlKit.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/**/*.swift"
end
