//
//  ViewController.swift
//  ZHHDropdownMenu
//
//  Created by 桃色三岁 on 06/06/2025.
//  Copyright (c) 2025 桃色三岁. All rights reserved.
//

import UIKit
import ZHHDropdownMenu

class ViewController: UIViewController {

    // MARK: - Properties
    
    // 示例1：基础菜单（商品类型）
    private lazy var menuView1: ZHHDropdownMenu = {
        let menu = ZHHDropdownMenu(frame: .zero)
        menu.dataSource = self
        menu.delegate = self
        
        // 边框和圆角
        menu.layer.borderColor = UIColor.systemOrange.cgColor
        menu.layer.borderWidth = 1
        menu.layer.cornerRadius = 8
        menu.layer.masksToBounds = true
        
        // 标题样式
        menu.menuTitle = "商品类型"
        menu.menuTitleBackgroundColor = UIColor.systemOrange
        menu.menuTitleFont = UIFont.boldSystemFont(ofSize: 15)
        menu.menuTitleTextColor = UIColor.white
        menu.menuTitleAlignment = .center
        menu.menuTitleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // 箭头图标
        menu.menuArrowIcon = UIImage(named: "icon_arrow_down")
        menu.menuArrowIconSize = CGSize(width: 18, height: 18)
        menu.menuArrowIconMarginRight = 10
        menu.menuArrowIconTintColor = UIColor.white
        
        // 选项样式
        menu.optionBackgroundColor = UIColor.white
        menu.optionTextFont = UIFont.systemFont(ofSize: 14)
        menu.optionTextColor = UIColor.label
        menu.optionTextAlignment = .left
        menu.optionTextMarginLeft = 15
        menu.optionNumberOfLines = 1
        menu.optionIconSize = CGSize(width: 15, height: 15)
        menu.optionIconMarginRight = 15
        
        // 分割线
        menu.separatorColor = UIColor.systemGray5
        menu.separatorInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        // 列表最大高度（超过则滚动）
        menu.optionsListMaxHeight = 200
        menu.showsVerticalScrollIndicator = true
        
        // 动画时长
        menu.animationDuration = 0.25
        
        return menu
    }()
    
    private let optionTitles1 = [
        "日用品", "食品", "电子产品", "个护化妆",
        "家居用品", "生鲜水果", "母婴用品", "宠物用品",
        "服装鞋帽", "图书文具"
    ]
    
    // 示例2：无图标菜单（城市选择）
    private lazy var menuView2: ZHHDropdownMenu = {
        let menu = ZHHDropdownMenu(frame: .zero)
        menu.dataSource = self
        menu.delegate = self
        
        // 边框和圆角
        menu.layer.borderColor = UIColor.systemBlue.cgColor
        menu.layer.borderWidth = 1
        menu.layer.cornerRadius = 6
        menu.layer.masksToBounds = true
        
        // 标题样式
        menu.menuTitle = "选择城市"
        menu.menuTitleBackgroundColor = UIColor.systemBlue
        menu.menuTitleFont = UIFont.systemFont(ofSize: 15)
        menu.menuTitleTextColor = UIColor.white
        menu.menuTitleAlignment = .left
        menu.menuTitleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        // 箭头图标
        menu.menuArrowIcon = UIImage(named: "icon_arrow_down")
        menu.menuArrowIconSize = CGSize(width: 16, height: 16)
        menu.menuArrowIconMarginRight = 12
        menu.menuArrowIconTintColor = UIColor.white
        
        // 选项样式（无图标）
        menu.optionBackgroundColor = UIColor.white
        menu.optionTextFont = UIFont.systemFont(ofSize: 14)
        menu.optionTextColor = UIColor.label
        menu.optionTextAlignment = .left
        menu.optionTextMarginLeft = 15
        menu.optionIconSize = CGSize(width: 0, height: 0) // 不显示图标
        
        // 分割线
        menu.separatorColor = UIColor.systemGray5
        menu.separatorInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        // 列表最大高度
        menu.optionsListMaxHeight = 160
        
        return menu
    }()
    
    private let optionTitles2 = [
        "北京", "上海", "广州", "深圳",
        "杭州", "成都", "武汉", "西安"
    ]
    
    // 示例3：自定义样式菜单（排序方式）
    private lazy var menuView3: ZHHDropdownMenu = {
        let menu = ZHHDropdownMenu(frame: .zero)
        menu.dataSource = self
        menu.delegate = self
        
        // 边框和圆角
        menu.layer.borderColor = UIColor.systemGreen.cgColor
        menu.layer.borderWidth = 1
        menu.layer.cornerRadius = 5
        menu.layer.masksToBounds = true
        
        // 标题样式
        menu.menuTitle = "排序"
        menu.menuTitleBackgroundColor = UIColor.systemGreen
        menu.menuTitleFont = UIFont.systemFont(ofSize: 13)
        menu.menuTitleTextColor = UIColor.white
        menu.menuTitleAlignment = .center
        menu.menuTitleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        // 箭头图标
        menu.menuArrowIcon = UIImage(named: "icon_arrow_down")
        menu.menuArrowIconSize = CGSize(width: 14, height: 14)
        menu.menuArrowIconMarginRight = 8
        menu.menuArrowIconTintColor = UIColor.white
        
        // 选项样式
        menu.optionBackgroundColor = UIColor.white
        menu.optionTextFont = UIFont.systemFont(ofSize: 13)
        menu.optionTextColor = UIColor.label
        menu.optionTextAlignment = .left
        menu.optionTextMarginLeft = 12
        menu.optionIconSize = CGSize(width: 12, height: 12)
        menu.optionIconMarginRight = 10
        
        // 分割线
        menu.separatorColor = UIColor.systemGray5
        menu.separatorInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        // 列表最大高度
        menu.optionsListMaxHeight = 200
        
        return menu
    }()
    
    private let optionTitles3 = [
        "综合排序", "价格从低到高", "价格从高到低",
        "销量最高", "最新上架"
    ]
    
    // 示例4：多行文本菜单（长文本选项）
    private lazy var menuView4: ZHHDropdownMenu = {
        let menu = ZHHDropdownMenu(frame: .zero)
        menu.dataSource = self
        menu.delegate = self
        
        // 边框和圆角
        menu.layer.borderColor = UIColor.systemPurple.cgColor
        menu.layer.borderWidth = 1
        menu.layer.cornerRadius = 8
        menu.layer.masksToBounds = true
        
        // 标题样式
        menu.menuTitle = "长文本选项"
        menu.menuTitleBackgroundColor = UIColor.systemPurple
        menu.menuTitleFont = UIFont.systemFont(ofSize: 15)
        menu.menuTitleTextColor = UIColor.white
        menu.menuTitleAlignment = .left
        menu.menuTitleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        // 箭头图标
        menu.menuArrowIcon = UIImage(named: "icon_arrow_down")
        menu.menuArrowIconSize = CGSize(width: 16, height: 16)
        menu.menuArrowIconMarginRight = 12
        menu.menuArrowIconTintColor = UIColor.white
        
        // 选项样式（支持多行）
        menu.optionBackgroundColor = UIColor.white
        menu.optionTextFont = UIFont.systemFont(ofSize: 14)
        menu.optionTextColor = UIColor.label
        menu.optionTextAlignment = .left
        menu.optionTextMarginLeft = 15
        menu.optionNumberOfLines = 0 // 0 表示不限制行数
        menu.optionIconSize = CGSize(width: 0, height: 0) // 长文本时不显示图标
        
        // 分割线
        menu.separatorColor = UIColor.systemGray5
        menu.separatorInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        // 列表最大高度
        menu.optionsListMaxHeight = 200
        
        return menu
    }()
    
    private let optionTitles4 = [
        "这是一个很长的选项文本，用来测试多行显示效果",
        "短文本",
        "另一个超长的选项文本内容，用于展示当文本内容很长时，菜单如何自适应显示",
        "普通选项"
    ]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ZHHDropdownMenu 示例"
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // 添加菜单视图
        setupMenus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 在布局完成后设置位置，避免使用 center（在 viewDidLoad 中可能不准确）
        let spacing: CGFloat = 20
        let menuHeight: CGFloat = 40
        let startY: CGFloat = 100
        
        menuView1.frame = CGRect(x: 15, y: startY, width: 136, height: menuHeight)
        menuView2.frame = CGRect(x: 15, y: startY + menuHeight + spacing, width: 150, height: menuHeight)
        menuView3.frame = CGRect(x: 15, y: startY + (menuHeight + spacing) * 2, width: 120, height: menuHeight)
        menuView4.frame = CGRect(x: 15, y: startY + (menuHeight + spacing) * 3, width: 200, height: menuHeight)
    }
    
    // MARK: - Setup
    
    private func setupMenus() {
        view.addSubview(menuView1)
        view.addSubview(menuView2)
        view.addSubview(menuView3)
        view.addSubview(menuView4)
    }
    
    // MARK: - Helper Methods
    
    private func menuName(for menu: ZHHDropdownMenu) -> String {
        switch menu {
        case menuView1:
            return "商品类型"
        case menuView2:
            return "城市选择"
        case menuView3:
            return "排序方式"
        case menuView4:
            return "长文本"
        default:
            return "未知"
        }
    }
}

// MARK: - ZHHDropdownMenuDataSource

extension ViewController: ZHHDropdownMenuDataSource {
    
    func numberOfOptions(in menu: ZHHDropdownMenu) -> Int {
        switch menu {
        case menuView1:
            return optionTitles1.count
        case menuView2:
            return optionTitles2.count
        case menuView3:
            return optionTitles3.count
        case menuView4:
            return optionTitles4.count
        default:
            return 0
        }
    }
    
    func dropdownMenu(_ menu: ZHHDropdownMenu, optionHeightAt index: Int) -> CGFloat {
        // 示例4 使用更大的高度以支持多行文本
        if menu == menuView4 {
            return 50
        }
        return 40
    }
    
    func dropdownMenu(_ menu: ZHHDropdownMenu, optionTitleAt index: Int) -> String {
        switch menu {
        case menuView1:
            return optionTitles1[index]
        case menuView2:
            return optionTitles2[index]
        case menuView3:
            return optionTitles3[index]
        case menuView4:
            return optionTitles4[index]
        default:
            return ""
        }
    }
    
    func dropdownMenu(_ menu: ZHHDropdownMenu, optionIconAt index: Int) -> UIImage? {
        // 只有示例1和示例3显示图标
        if menu == menuView1 || menu == menuView3 {
            return UIImage(named: "icon_flame_small")
        }
        return nil
    }
}

// MARK: - ZHHDropdownMenuDelegate

extension ViewController: ZHHDropdownMenuDelegate {
    
    func dropdownMenuWillAppear(_ menu: ZHHDropdownMenu) {
        let menuName = menuName(for: menu)
        print("菜单即将展开: \(menuName)")
    }
    
    func dropdownMenuDidAppear(_ menu: ZHHDropdownMenu) {
        print("菜单已展开")
    }
    
    func dropdownMenuWillDisappear(_ menu: ZHHDropdownMenu) {
        print("菜单即将关闭")
    }
    
    func dropdownMenuDidDisappear(_ menu: ZHHDropdownMenu) {
        print("菜单已关闭")
    }
    
    func dropdownMenu(_ menu: ZHHDropdownMenu, didSelectOptionAt index: Int, title: String) {
        let menuName = menuName(for: menu)
        print("【\(menuName)】选择了：index: \(index) - title: \(title)")
        
        // 可以在这里添加 UI 反馈，比如显示提示
        let alert = UIAlertController(
            title: "选择结果",
            message: "\(menuName)\n索引: \(index)\n标题: \(title)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
