#
# Be sure to run `pod lib lint SwiftJSONi.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftJSONi'
  s.version          = '0.1.1'
  s.summary          = 'A Light weight Swift JSON Model, that allows to use JSON the way it has to be'
  s.swift_version    = '4.2'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A light weight Swift JSON Model, completely written in Swift, that makes handling JSON data in Swift and Objective-C very easy and safe. No more type casting of data and safe unwraping. No more crashing because of force unwraping, Index Out of bound, missing key etc.. Its totally nil safe as all the optional handling is done. The model is basically of struct type making it even thread safe and very light. It supports chaining. This lib makes your code a lot neater, simpler and more readable. SwiftJSONi follows the rules of JSON described under RC-7129 and www.json.org. It allows parsing fragments.
                       DESC

  s.homepage         = 'https://github.com/akaashdev/SwiftJSONi'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Akaash Dev' => 'heatblast.akaash@gmail.com' }
  s.source           = { :git => 'https://github.com/akaashdev/SwiftJSONi.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/akaash_dev'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SwiftJSONi/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SwiftJSONi' => ['SwiftJSONi/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
