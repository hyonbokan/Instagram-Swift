# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Instagram' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Instagram
pod 'Appirater'
pod 'SDWebImage'
# Firebase
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Analytics'
pod 'Firebase/Crashlytics'
pod 'Firebase/Storage'
pod 'Firebase/Firestore'

end

# Add post-installation script to set deployment target
post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end