#
# Be sure to run `pod lib lint MHExtendedMenuControl.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "MHExtendedMenuControl"
s.version          = "0.2.0"
s.summary          = "MHExtendedMenuControl Library"
s.description      = <<-DESC
MHExtendedMenuControl allows you to create a bouncing menu with multiple buttons
DESC
s.homepage         = "https://github.com/Ptitematil2/MHExtendedMenuControl"
s.license          = 'MIT'
s.author           = { "Mathilde Henriot" => "me@mathilde-henriot.com" }
s.source           = { :git => "https://github.com/Ptitematil2/MHExtendedMenuControl.git", :tag => "0.2.0" }
s.social_media_url = 'https://twitter.com/Ptitematil2'

s.platform     = :ios, '7.0'
s.requires_arc = true

s.source_files = 'Pod/Classes/**/*'
s.resource_bundles = {
'MHExtendedMenuControl' => ['Pod/Assets/*.png']
}

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
