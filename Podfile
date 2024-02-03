post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
    end
  end
end
# Uncomment the next line to define a global platform for your project
 platform :ios, '15.0'
inhibit_all_warnings!

target 'Go2meTRO' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for Go2meTRO
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxAlamofire'
  pod 'RxDataSources'



  target 'Go2meTROTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxAlamofire'
    pod 'RxDataSources'
  end

  target 'Go2meTROUITests' do
    # Pods for testing
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxAlamofire'
    pod 'RxDataSources'
  end

end
