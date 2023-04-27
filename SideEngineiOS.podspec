Pod::Spec.new do |spec|
  spec.name         = "SideEngineiOS"
  spec.version      = "1.0.0"
  spec.summary      = "Powerful Real-Time Incident Detection, Prevention and Alerting"
  spec.description  = <<-DESC
                    The Flare SDK is an innovative solution that enables mobility providers, food couriers, and insurers to gain a deeper understanding of accidents like never before. With our real-time incident detection, prevention, and alerting capabilities, you can take your safety measures to the next level and offer enhanced safety features to your customers.
                   DESC
  spec.homepage     = "https://github.com/k-safe/flare_sdk_ios.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "K-Safe Ltd" => "busby@k-safe.com" }
  spec.platform     = :ios, "12.1"
  spec.source       = { :http => 'file:' + __dir__ + "/" }
 spec.source       = { :git => "https://github.com/k-safe/flare_sdk_ios.git", :tag => "#{spec.version}" }
   spec.ios.vendored_frameworks = 'BBSideEngine.xcframework'
  spec.swift_version = "5.0"
end
