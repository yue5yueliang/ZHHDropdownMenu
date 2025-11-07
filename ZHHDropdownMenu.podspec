Pod::Spec.new do |s|
  s.name             = 'ZHHDropdownMenu'
  s.version          = '0.0.3'
  s.summary          = '一个简洁易用的下拉菜单组件，支持自定义样式、高亮效果和性能优化。'

  s.description      = <<-DESC
  ZHHDropdownMenu 是一个轻量级、高性能的 iOS 下拉菜单组件，基于 UIKit 实现。
  
  主要特性：
  - 🎨 丰富的自定义样式：支持自定义标题、选项、图标、颜色、字体等
  - ⚡ 性能优化：内置缓存机制，减少重复计算，提升滚动流畅度
  - ✨ 点击高亮效果：支持自定义高亮背景颜色，提供良好的交互反馈
  - 📱 灵活配置：支持最大高度限制、滚动、多行文本等
  - 🔄 完整的生命周期回调：支持展开/收起前后的代理回调
  - 🎯 易于集成：简洁的 API 设计，支持数据源和代理模式
  
  适用于表单选择、筛选菜单、操作列表、排序选择等场景。
  最低支持 iOS 13.0。
  DESC

  s.homepage         = 'https://github.com/yue5yueliang/ZHHDropdownMenu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 
    '桃色三岁' => '136769890@qq.com'
  }
  s.source           = { 
    :git => 'https://github.com/yue5yueliang/ZHHDropdownMenu.git', 
    :tag => s.version.to_s 
  }
  
  s.social_media_url = 'https://github.com/yue5yueliang'
  s.requires_arc     = true
  s.ios.deployment_target = '13.0'
  s.swift_version    = nil  # 纯 Objective-C 项目

  s.default_subspec = 'Core'
  
  s.subspec 'Core' do |core|
    core.source_files = 'ZHHDropdownMenu/Classes/**/*.{h,m}'
    core.public_header_files = 'ZHHDropdownMenu/Classes/**/*.h'
    core.frameworks = 'UIKit', 'Foundation'
    
    # 排除示例和测试文件
    core.exclude_files = [
      'ZHHDropdownMenu/Classes/**/*Tests.{h,m}',
      'ZHHDropdownMenu/Example/**/*'
    ]
  end
end
