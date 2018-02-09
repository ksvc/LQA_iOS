

Pod::Spec.new do |s|

  s.name         = "LQASDK"
  s.version      = "1.0"
  s.summary      = "问答sdk"
  s.ios.deployment_target = "8.0"

  s.description  = <<-DESC
                    * KSYTest sdk
                   DESC

  s.homepage     = "http://v.ksyun.com/doc.html"
  s.license      = {:type => 'Proprietary', :text => <<-LICENSE
  Copyright 2015 kingsoft Ltd. All rights reserved.
  LICENSE
  }

  s.author             = { "yuyang10" => "yuyang10@kingsoft.com" }
  s.source       ={ :git => "git@newgit.op.ksyun.com:sdk/LQA-iOS.git", :tag => "v#{s.version}" }

  s.source_files = [
     'LQASDK/*.pch',
     'LQASDK/*.plist',
     'LQASDK/*.{h,m}',
     'LQASDK/*/*.{h,m}',   
   ]
   s.pod_target_xcconfig = {'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}"/**',
   'OTHER_LDFLAGS'          => '-fembed-bitcode',
   'ENABLE_BITCODE'         => 'YES'
   }

  s.vendored_frameworks = "libs/*.framework"
  s.requires_arc = true
  s.dependency "RongCloudIMLib"
  s.dependency "MJExtension"
  s.dependency "KSYMediaPlayer_iOS"
end
