#
# Be sure to run `pod lib lint STLocationRequest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = "STLocationRequest"
    s.version          = "1.3.5"
    s.summary          = "A simple and elegant way to request the user location"
    s.description  = <<-DESC
                        A simple user interface to request the user location. With nice citys and a rotating 3D Map View
                    DESC
    s.homepage         = "https://github.com/SvenTiigi/STLocationRequest"
    s.license          = 'MIT'
    s.author           = { "Sven Tiigi" => "sven@tiigi.de" }
    s.source           = { :git => "https://github.com/SvenTiigi/STLocationRequest.git", :tag => s.version.to_s }
    s.platform     = :ios, '8.0'
    s.requires_arc = true
    s.source_files = 'Pod/Source/**/*'
    s.resource_bundles = {
        'STLocationRequest' => ['Pod/Assets/*.png']
    }
    s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'Font-Awesome-Swift', '~> 1.6.1'
    s.resource_bundles = {
        'STLocationRequest' => ['Pod/Assets/*.storyboard']
    }
end
