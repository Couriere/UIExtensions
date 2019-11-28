
Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "UIExtensions"
  spec.version      = "1.2.1"
  spec.summary      = "Convenience extensions to UIKit and Foundation classes."

  spec.homepage     = "https://github.com/Couriere/UIExtensions"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.license      = { :type => 'MIT' }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author       = { "Vladimir Kazantsev" => "8406740@gmail.com" }
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.swift_version = '5.0'
  spec.ios.deployment_target = "9.0"
  spec.tvos.deployment_target = "10.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => "https://github.com/Couriere/UIExtensions.git", :tag => spec.version }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source_files  = "Sources/{Classes,Foundation,UI}/*.swift"
  spec.ios..source_files  = "Sources/UI/iOS/*.swift"
  #spec.exclude_files = "Classes/Exclude"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.framework  = "UIKit"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # spec.dependency "JSONKit", "~> 1.4"

end
