Pod::Spec.new do |s|
    s.name                      = "STLocationRequest"
    s.version                   = "3.3.0"
    s.summary                   = "Request the users location services via an 3D 360° Flyover MapView"
    s.homepage                  = "https://github.com/SvenTiigi/STLocationRequest"
    s.social_media_url          = 'http://twitter.com/SvenTiigi'
    s.license                   = 'MIT'
    s.author                    = { "Sven Tiigi" => "sven.tiigi@gmail.com" }
    s.source                    = { :git => "https://github.com/SvenTiigi/STLocationRequest.git", :tag => s.version.to_s }
    s.ios.deployment_target     = "10.0"
    s.tvos.deployment_target    = "10.0"
    s.source_files              = 'Sources/**/*'
    s.frameworks                = 'Foundation', 'UIKit', 'MapKit'
    s.dependency 'FlyoverKit', '1.2.2'
end
