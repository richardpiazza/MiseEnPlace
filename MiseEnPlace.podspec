#
# Be sure to run `pod lib lint MiseEnPlace.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name = "MiseEnPlace"
  s.version = "4.0.1"
  s.summary = "A Framework for converting and interpreting common measurements used in cooking."
  s.description = <<-DESC
  MiseEnPlace provides powerfull conversion and interpretation for any cooking application.
  MiseEnPlace makes it easy to convert between US and Metric measurements and display the results
  in a human readable way.
                       DESC
  s.homepage = "https://github.com/richardpiazza/MiseEnPlace"
  s.license = 'MIT'
  s.author = { "Richard Piazza" => "github@richardpiazza.com" }
  s.social_media_url = 'https://twitter.com/richardpiazza'

  s.source = { :git => "https://github.com/richardpiazza/MiseEnPlace.git", :tag => s.version.to_s }
  s.frameworks = 'Foundation'
  s.requires_arc = true

  s.osx.deployment_target = "10.12"
  s.osx.frameworks = 'Foundation'
  s.osx.source_files = 'Sources/Foundation/*'

  s.ios.deployment_target = "10.0"
  s.ios.frameworks = 'Foundation', 'UIKit'
  s.ios.source_files = 'Sources/Foundation/*', 'Sources/iOS/*'
  s.ios.resources = 'Resources/iOS/*'

  s.tvos.deployment_target = "10.0"
  s.tvos.frameworks = 'Foundation'
  s.tvos.source_files = 'Sources/Foundation/*'

  s.watchos.deployment_target = "3.0"
  s.watchos.frameworks = 'Foundation'
  s.watchos.source_files = 'Sources/Foundation/*'
end
