Pod::Spec.new do |s|
  s.name = "MiseEnPlace"
  s.version = "5.0.0"
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
  s.source_files = 'Sources/*'

  s.osx.deployment_target = "10.13"
  s.osx.frameworks = 'Foundation'

  s.ios.deployment_target = "11.0"
  s.ios.frameworks = 'Foundation', 'UIKit'
  s.ios.resources = 'Resources/*'

  s.tvos.deployment_target = "11.0"
  s.tvos.frameworks = 'Foundation'

  s.watchos.deployment_target = "4.0"
  s.watchos.frameworks = 'Foundation'
end
