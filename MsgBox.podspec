Pod::Spec.new do |s|

  s.name         = "MsgBox"
  s.version      = "0.1.1"
  s.summary      = "MsgBox can build Chat by linking Firestore and Realm."
  s.description  = <<-DESC
Since Firestore takes time even when reading from the local, we decided to use Realm locally.
                   DESC

  s.homepage     = "https://github.com/1amageek/MsgBox"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "1amageek" => "tmy0x3@icloud.com" }
  s.social_media_url   = "http://twitter.com/1amageek"
  s.platform     = :ios, "11.0"
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/1amageek/MsgBox.git", :tag => "#{s.version}" }
  s.source_files  = "MsgBox/**/*.swift"
  s.requires_arc = true
  s.static_framework = true
  s.dependency "RealmSwift"
  s.dependency "Pring"
  s.dependency "Firebase/Core"
  s.dependency "Firebase/Firestore"
  s.dependency "OnTheKeyboard"
  s.dependency "Texture"

end
