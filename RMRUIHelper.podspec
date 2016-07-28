Pod::Spec.new do |s|
   s.name = 'RMRUIHelper'
   s.version = '1.0'
   s.license = 'MIT'

   s.summary = 'Lib RMRUIHelper'
   s.homepage = 'https://github.com/Klimowsa/RMRUIHelper'
   s.author = 'RMR + AGIMA'

   s.source = { :git => 'https://github.com/Klimowsa/RMRUIHelper.git', :tag => s.version }
   s.source_files = 'RMRUIHelper/Pod/**/*.{h,m}'

   s.platform = :ios
   s.ios.deployment_target = '8.0'

   s.frameworks = 'Realm'

   s.requires_arc = true
end