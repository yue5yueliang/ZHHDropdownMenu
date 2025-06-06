Pod::Spec.new do |s|
  s.name             = 'ZHHDropdownMenu'
  s.version          = '0.0.2'
  s.summary      = '一个简洁易用的下拉菜单组件，支持自定义样式和交互。'

  s.description  = <<-DESC
  ZHHDropdownMenu 是一个轻量级的 iOS 下拉菜单组件，基于 UIKit 实现，支持自定义选项样式、
  弹出方向、点击回调等，适用于表单选择、筛选菜单、操作列表等场景，最低支持 iOS 13。
  DESC

  s.homepage         = 'https://github.com/yue5yueliang/ZHHDropdownMenu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '桃色三岁' => '136769890@qq.com' }
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHDropdownMenu.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.default_subspec = 'Core'
  
  s.subspec 'Core' do |core|
    core.source_files = 'ZHHDropdownMenu/Classes/**/*'
    # 如果需要，添加依赖项或资源文件
    # core.resources = ['ZHHDropdownMenu/Assets/*.xcassets']
  end
end
