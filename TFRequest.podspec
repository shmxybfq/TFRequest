
Pod::Spec.new do |s|

  s.name         = "TFRequest"
  s.version      = "1.5.1"
  s.summary      = "a afn sub classes"
  s.description  = <<-DESC
    a afn sub classes for self
                   DESC
  s.homepage     = "https://github.com/shmxybfq/TFRequest"
  s.license      = "MIT"
  s.author             = { "zhutaofeng" => "shmxybfq@163.com" }
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/shmxybfq/TFRequest.git", :tag => "#{s.version}" }
  s.source_files  = "TFRequest/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc = true
  s.dependency "AFNetworking", '~> 4.0.1'
end
