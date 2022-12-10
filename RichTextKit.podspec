Pod::Spec.new do |s|
  s.name             = 'RichTextKit'
  s.version          = '0.2.0'
  s.swift_versions   = ['5.6']
  s.summary          = 'RichTextKit is a Swift-based library for working with rich text in UIKit, AppKit and SwiftUI.'
  s.description      = 'RichTextKit is a Swift-based library for working with rich text in UIKit, AppKit and SwiftUI. It adds extensions to native types, new views and a great SwiftUI integrations.'

  s.homepage         = 'https://github.com/danielsaidi/RichTextKit'
  s.license          = { :type => 'NONE', :file => 'LICENSE' }
  s.author           = { 'Daniel Saidi' => 'daniel.saidi@gmail.com' }
  s.source           = { :git => 'https://github.com/danielsaidi/RichTextKit.git', :tag => s.version.to_s }
  
  s.swift_version = '5.6'
  s.ios.deployment_target = '14.0'
  s.tvos.deployment_target = '14.0'
  s.macos.deployment_target = '12'
  s.watchos.deployment_target = '8.0'
  
  s.source_files = 'Sources/RichTextKit/**/*.swift'
end
