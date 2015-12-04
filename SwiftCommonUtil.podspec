Pod::Spec.new do |s|
s.name = 'SwiftCommonUtil'
s.version = '0.0.1'
s.license = 'MIT'
s.summary = 'SwiftCommonUtil'
s.authors = { 'itlijunjie' => 'itlijunjie@gmail.com' }
s.source = { :git => 'https://github.com/GagSquad/SwiftCommonUtil.git' }

s.ios.deployment_target = '8.0'

s.source_files = 'CommonUtil/**/*.swift'

s.requires_arc = true
end