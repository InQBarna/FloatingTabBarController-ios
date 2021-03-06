Pod::Spec.new do |s|
s.name             = "FloatingTabBarController"
s.version          = "0.2.3"
s.summary          = "A floating tab bar controller"
s.description      = <<-DESC
A floating tab bar controller
DESC
s.homepage         = 'https://github.com/InQBarna/FloatingTabBarController-ios'
s.license          = 'MIT'
s.author           = { 'David Romacho' => 'david.romacho@inqbarna.com' }
s.source           = { :git => "https://github.com/InQBarna/FloatingTabBarController-ios.git", :tag => 'v0.2.3' }

s.ios.deployment_target = '10.0'
s.requires_arc = true
s.source_files = 'Sources/FloatingTabBarController/*'
s.swift_version = '5.0'

s.frameworks = 'UIKit'
end
