#
# Be sure to run `pod lib lint CHBannerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CHBannerView'
  s.version          = '0.1.2'
  s.summary          = 'BannerView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
It is a simple banner view.
                       DESC

  s.homepage         = 'https://github.com/chinghoi/CHBannerView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chinghoi' => '56465334@qq.com' }
  s.source           = { :git => 'https://github.com/chinghoi/CHBannerView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_versions = ['5']
  s.ios.deployment_target = '10.3'

  s.source_files = 'CHBannerView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CHBannerView' => ['CHBannerView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.dependency 'AlamofireImage', '~> 4.1'
end
