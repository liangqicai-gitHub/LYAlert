#
# Be sure to run `pod lib lint LYAlert.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LYAlert'
  s.version          = '0.1.3'
  s.summary          = 'use for alter'


  s.description      = <<-DESC
when you want to do alter, it can be some help
                       DESC

  s.homepage         = 'https://github.com/liangqicai-gitHub/LYAlert'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sunny' => '2468751795@qq.com' }
  s.source           = { :git => 'https://github.com/liangqicai-gitHub/LYAlert.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'LYAlert/Classes/**/*'
  s.swift_versions = [5.0]

  s.dependency 'RxSwift', '6.5.0'
  s.dependency 'RxCocoa', '6.5.0'
  s.dependency 'SnapKit', '5.6.0'

  # s.resource_bundles = {
  #   'LYAlert' => ['LYAlert/Assets/*.png']
  # }

  #s.public_header_files = 'Pod/Classes/**/*.h'
  #s.swift_versions = [5.0]
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
