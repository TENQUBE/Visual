#
# Be sure to run `pod lib lint Visual.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Visual'
  s.version          = '0.2.6'
  s.summary          = 'A short description of Visual.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "visual money manager"

  s.homepage         = 'http://tenqube.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kj.sa@tenqube.com' => 'kj.sa@tenqube.com' }
  s.source           = { :git => 'https://github.com/TENQUBE/Visual.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Visual/Classes/**/*'
  s.static_framework = true
   
   s.resource_bundles = {
       'Visual' => ['Visual/Assets/**/*.{storyboard,bundle,plist}']
   }
   

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'WebKit'
   
   s.dependency 'Alamofire'
   s.dependency 'SwiftLint'
   s.dependency 'RealmSwift'
   s.dependency 'SwiftyJSON'
   
   s.dependency 'VisualParser'
   
 

end
