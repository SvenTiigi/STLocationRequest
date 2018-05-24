Pod::Spec.new do |s|
    s.name             = "STLocationRequest"
    s.version          = "3.2.2"
    s.summary          = "Request the users location services via an 3D 360° Flyover MapView"
    s.homepage         = "https://github.com/SvenTiigi/STLocationRequest"
    s.social_media_url = 'http://twitter.com/SvenTiigi'
    s.license          = 'MIT'
    s.author           = { "Sven Tiigi" => "sven.tiigi@gmail.com" }
    s.source           = { :git => "https://github.com/SvenTiigi/STLocationRequest.git", :tag => s.version.to_s }
    s.platform         = :ios, '10.0'
    s.requires_arc     = true
    s.source_files     = 'STLocationRequest/**/*'
    s.frameworks       = 'UIKit', 'MapKit'
    s.dependency 'FlyoverKit', '1.2.0'
    s.dependency 'SnapKit', '4.0.0'
    s.dependency 'SwiftIconFont', '2.8.0'
end
