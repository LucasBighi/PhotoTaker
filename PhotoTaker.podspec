Pod::Spec.new do |spec|

  spec.name         = "PhotoTaker"
  spec.version      = "0.0.1"
  spec.summary      = "A CocoaPods library written in Swift"

  spec.description  = <<-DESC
This CocoaPods library helps you to choose or take a Photo from Library or Camera.
                   DESC

  spec.homepage     = "https://github.com/LucasBighi/PhotoTaker"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Lucas Bighi" => "lucasmbighi@icloud.com" }

  spec.ios.deployment_target = "12.1"
  spec.swift_version = "5"

  spec.source        = { :git => "https://github.com/LucasBighi/PhotoTaker.git", :tag => "#{spec.version}" }
  spec.source_files  = "PhotoTaker/**/*.{h,m,swift}"

end
