#
# Be sure to run `pod lib lint MiseEnPlace.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MiseEnPlace"
  s.version          = "1.0.4"
  s.summary          = "A Framework for converting and interpreting common measurements used in cooking."
  s.description      = <<-DESC
  MiseEnPlace provides powerfull conversion and interpretation for any cooking application.
  MiseEnPlace makes it easy to convert between US and Metric measurements and display the results
  in a human readable way.
                       DESC
  s.homepage = "https://github.com/richardpiazza/MiseEnPlace"
  s.license = 'MIT'
  s.author = { "Richard Piazza" => "github@richardpiazza.com" }
  s.social_media_url = 'https://twitter.com/richardpiazza'

  s.source = { :git => "https://github.com/richardpiazza/MiseEnPlace.git", :tag => s.version.to_s }
  s.source_files = 'Sources/*'
  s.platform = :ios, '9.1'
  s.frameworks = 'Foundation'
  s.requires_arc = true

end
