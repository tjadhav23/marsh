# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyBenefits360' do
# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

# Pods for MyBenefits360



pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'Fabric', '~> 1.7.7'
pod 'Firebase/Crashlytics'
pod 'Firebase/Core'
pod 'FirebaseAnalytics'

pod 'AEXML'
pod ‘StepIndicator’, '~> 1.0.6’

pod 'SDWebImage'
pod "FlexibleSteppedProgressBar"
pod 'MBProgressHUD', '~> 1.1.0'

pod 'Alamofire', '~> 4.8.1'
pod 'SwiftyJSON', '~> 4.0'
pod "SkeletonView"
pod 'Firebase/Messaging'

pod 'Shimmer'

pod "CenteredCollectionView"
pod 'lottie-ios'

pod 'Charts', '~> 4.1.0'
pod 'PromiseKit', '~> 6.0'
pod 'Apollo', '= 0.10.1'
pod 'GzipSwift', '= 5.0.0'

pod 'JTAppleCalendar', '~> 7.1.7'
pod 'SlideMenuControllerSwift'
pod 'EncryptedCoreData'
pod 'IOSSecuritySuite'
pod 'SVGKit'
pod 'TrustKit'
pod 'CocoaAsyncSocket'

target 'MyBenefits360Tests' do
inherit! :search_paths
# Pods for testing
end

target 'MyBenefits360UITests' do
inherit! :search_paths
# Pods for testing
end

# Add the post_install block here
post_install do |installer|
  installer.aggregate_targets.each do |target|
    target.xcconfigs.each do |variant, xcconfig|
      xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
      IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
    end
  end

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
        xcconfig_path = config.base_configuration_reference.real_path
        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end
    end
  end
end

end
