Pod::Spec.new do |s|
   s.name = 'RMRUIHelper'
   s.version = '1.0'
   s.license = 'AGIMA'

   s.summary = 'Lib RMRUIHelper'
   s.homepage = 'https://github.com/Klimowsa/RMRUIHelper'
   s.author = 'RMR + AGIMA'

   s.source = { :git => 'https://github.com/Klimowsa/RMRUIHelper.git', :tag => s.version }
   s.source_files = 'RMRUIHelper/Pod/'

   s.ios.deployment_target = '8.0'
   s.osx.deployment_target = '10.10'

   s.frameworks = 'CoreData'

   s.requires_arc = true
end