Pod::Spec.new do |s|
    s.name             = "STLocationRequest"
    s.version          = "2.0.0"
    s.summary          = "A simple and elegant 3D-Flyover location request screen written in Swift"
    s.homepage         = "https://github.com/SvenTiigi/STLocationRequest"
    s.social_media_url = 'http://twitter.com/SvenTiigi'
    s.license          = 'MIT'
    s.author           = { "Sven Tiigi" => "sven.tiigi@gmail.com" }
    s.source           = { :git => "https://github.com/SvenTiigi/STLocationRequest.git", :tag => s.version.to_s }
    s.platform         = :ios, '9.0'
    s.requires_arc     = true
    s.source_files     = 'Sources/**/*'
    s.frameworks       = 'UIKit', 'MapKit'
    s.dependency 'Font-Awesome-Swift'
end
