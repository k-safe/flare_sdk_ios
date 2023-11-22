Pod::Spec.new do |spec|
  spec.name         = "SideEngine-iOS"
  spec.version      = "4.3.0"
  spec.summary      = "Powerful Real-Time Incident Detection, Prevention and Alerting"
  spec.description  = <<-DESC
                    The Flare SDK is an innovative solution that enables mobility providers, food couriers, and insurers to gain a deeper understanding of accidents like never before. With our real-time incident detection, prevention, and alerting capabilities, you can take your safety measures to the next level and offer enhanced safety features to your customers.
                   DESC
  spec.homepage     = "https://developers.flaresafety.com/"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "K-Safe Ltd" => "flare@k-safe.com" }
  spec.platform     = :ios, "13.0"
  spec.source       = { :http => 'file:' + __dir__ + "/" }
spec.source       = { :git => "https://github.com/k-safe/flare_sdk_ios.git", :tag => "#{spec.version}" }
   spec.ios.vendored_frameworks = 'BBSideEngine.xcframework'
  spec.swift_version = "5.0"
  spec.dependency 'TensorFlowLiteSwift', '2.13.0'
end
