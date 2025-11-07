//
//  ZHHDropdownMenu.swift
//  ZHHDropdownMenu
//
//  Created by 桃色三岁 on 2025/3/24.
//  Copyright © 2025 桃色三岁. All rights reserved.
//

import UIKit

// MARK: - Protocols

/// 下拉菜单的数据源协议
public protocol ZHHDropdownMenuDataSource: AnyObject {
    /// 获取下拉菜单的选项数量
    func numberOfOptions(in menu: ZHHDropdownMenu) -> Int
    
    /// 获取指定索引选项的高度
    func dropdownMenu(_ menu: ZHHDropdownMenu, optionHeightAt index: Int) -> CGFloat
    
    /// 获取指定索引选项的标题
    func dropdownMenu(_ menu: ZHHDropdownMenu, optionTitleAt index: Int) -> String
    
    /// 获取指定索引选项的图标（可选）
    func dropdownMenu(_ menu: ZHHDropdownMenu, optionIconAt index: Int) -> UIImage?
}

/// 下拉菜单的代理协议
public protocol ZHHDropdownMenuDelegate: AnyObject {
    /// 下拉菜单即将展开（可选）
    func dropdownMenuWillAppear(_ menu: ZHHDropdownMenu)
    
    /// 下拉菜单已经展开（可选）
    func dropdownMenuDidAppear(_ menu: ZHHDropdownMenu)
    
    /// 下拉菜单即将收起（可选）
    func dropdownMenuWillDisappear(_ menu: ZHHDropdownMenu)
    
    /// 下拉菜单已经收起（可选）
    func dropdownMenuDidDisappear(_ menu: ZHHDropdownMenu)
    
    /// 选中某个选项（可选）
    func dropdownMenu(_ menu: ZHHDropdownMenu, didSelectOptionAt index: Int, title: String)
}

/// 协议扩展：提供可选方法的默认实现
public extension ZHHDropdownMenuDelegate {
    func dropdownMenuWillAppear(_ menu: ZHHDropdownMenu) {}
    func dropdownMenuDidAppear(_ menu: ZHHDropdownMenu) {}
    func dropdownMenuWillDisappear(_ menu: ZHHDropdownMenu) {}
    func dropdownMenuDidDisappear(_ menu: ZHHDropdownMenu) {}
    func dropdownMenu(_ menu: ZHHDropdownMenu, didSelectOptionAt index: Int, title: String) {}
}

// MARK: - ZHHDropdownMenu

/// 下拉菜单组件
public class ZHHDropdownMenu: UIView {
    
    // MARK: - DataSource & Delegate
    
    /// 数据源代理，用于提供选项数据
    public weak var dataSource: ZHHDropdownMenuDataSource?
    
    /// 事件代理，用于监听菜单的展开、隐藏和选中事件
    public weak var delegate: ZHHDropdownMenuDelegate?
    
    // MARK: - 标题相关（Title）
    
    /// 下拉菜单的主标题文本
    public var menuTitle: String = "请选择" {
        didSet {
            menuButton.setTitle(menuTitle, for: .normal)
        }
    }
    
    /// 菜单标题的背景颜色（默认：蓝色）
    public var menuTitleBackgroundColor: UIColor? {
        didSet {
            updateMenuButtonBackground()
        }
    }
    
    /// 菜单标题的字体（默认：系统字体 15 号粗体）
    public var menuTitleFont: UIFont = .boldSystemFont(ofSize: 15) {
        didSet {
            menuButton.titleLabel?.font = menuTitleFont
            menuButton.setNeedsLayout()
        }
    }
    
    /// 菜单标题的文字颜色（默认：白色）
    public var menuTitleTextColor: UIColor = .white {
        didSet {
            menuButton.setTitleColor(menuTitleTextColor, for: .normal)
            menuButton.setNeedsLayout()
        }
    }
    
    /// 菜单标题的文字对齐方式（默认：左对齐）
    public var menuTitleAlignment: NSTextAlignment = .left {
        didSet {
            let alignment: UIControl.ContentHorizontalAlignment
            switch menuTitleAlignment {
            case .left:
                alignment = .left
            case .center:
                alignment = .center
            case .right:
                alignment = .right
            default:
                alignment = .center
            }
            menuButton.contentHorizontalAlignment = alignment
            menuButton.setNeedsLayout()
        }
    }
    
    /// 菜单标题的边距（默认为 UIEdgeInsetsZero，可用于调整内边距）
    public var menuTitleEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) {
        didSet {
            menuButton.titleEdgeInsets = menuTitleEdgeInsets
            menuButton.setNeedsLayout()
        }
    }
    
    // MARK: - 旋转图标（Rotate Icon）
    
    /// 右侧旋转箭头图标（通常用于指示下拉菜单状态）
    public var menuArrowIcon: UIImage? {
        didSet {
            arrowImageView.image = menuArrowIcon
        }
    }
    
    /// 旋转图标的大小（默认：CGSize(15, 15)）
    public var menuArrowIconSize: CGSize = CGSize(width: 15, height: 15) {
        didSet {
            updateRotateIconFrame()
        }
    }
    
    /// 旋转图标距离右侧的间距（默认：7.5）
    public var menuArrowIconMarginRight: CGFloat = 7.5 {
        didSet {
            updateRotateIconFrame()
        }
    }
    
    /// 旋转图标的颜色（仅适用于可更改颜色的图片，如 `UIImageRenderingModeAlwaysTemplate`）
    public var menuArrowIconTintColor: UIColor = .black {
        didSet {
            arrowImageView.tintColor = menuArrowIconTintColor
        }
    }
    
    // MARK: - 选项样式（Option Style）
    
    /// 选项的背景颜色（默认：半透明蓝色）
    public var optionBackgroundColor: UIColor = UIColor(red: 64/255.0, green: 151/255.0, blue: 255/255.0, alpha: 0.5)
    
    /// 选项的字体（默认：系统字体 13 号）
    public var optionTextFont: UIFont = .systemFont(ofSize: 13)
    
    /// 选项的文本颜色（默认：黑色）
    public var optionTextColor: UIColor = .black
    
    /// 选项文本的对齐方式（默认：居中）
    public var optionTextAlignment: NSTextAlignment = .center
    
    /// 选项文本距离左侧的间距（默认：15）
    public var optionTextMarginLeft: CGFloat = 15
    
    /// 选项文本的最大行数（默认：0，不限制）
    public var optionNumberOfLines: Int = 0
    
    /// 选项图标的大小（默认：CGSizeZero）
    public var optionIconSize: CGSize = .zero
    
    /// 选项图标距离右侧的间距（默认：15）
    public var optionIconMarginRight: CGFloat = 15
    
    /// 选项之间分割线的颜色（默认：系统TableViewCell的颜色）
    public var separatorColor: UIColor?
    
    /// 分割线的边距
    public var separatorInsets: UIEdgeInsets = .zero
    
    // MARK: - 选项列表（Options List）
    
    /// 选项列表的最大显示高度，超过此高度则会滚动
    /// - 当 `optionsListMaxHeight <= 0` 时，菜单会展示所有选项，不受高度限制（默认值：0）
    public var optionsListMaxHeight: CGFloat = 0
    
    /// 是否显示选项列表的垂直滚动条（默认：true）
    public var showsVerticalScrollIndicator: Bool = true {
        didSet {
            dropdownList.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        }
    }
    
    // MARK: - 动画相关（Animation）
    
    /// 下拉动画的时长（默认：0.25 秒）
    public var animationDuration: TimeInterval = 0.25
    
    // MARK: - Private Properties
    
    /// 主要的菜单按钮，点击后展开或收起下拉列表
    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = menuTitleEdgeInsets
        button.setTitle(menuTitle, for: .normal)
        button.setTitleColor(menuTitleTextColor, for: .normal)
        button.titleLabel?.font = menuTitleFont
        button.addTarget(self, action: #selector(clickMenuBtnAction(_:)), for: .touchUpInside)
        return button
    }()
    
    /// 下拉菜单的箭头指示图标，表示展开或收起状态
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = menuArrowIconTintColor
        return imageView
    }()
    
    /// 下拉菜单的选项列表
    private lazy var dropdownList: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = separatorColor
        tableView.separatorInset = separatorInsets
        tableView.isScrollEnabled = false
        
        // 减少不必要的视图更新
        tableView.estimatedRowHeight = 0 // 禁用估算高度，使用精确高度
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        // 优化滚动性能
        tableView.delaysContentTouches = false // 减少触摸延迟
        tableView.canCancelContentTouches = true
        
        return tableView
    }()
    
    /// 悬浮的菜单容器视图，包含 `dropdownList`，用于显示下拉菜单
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        return view
    }()
    
    /// 遮罩视图，点击遮罩可关闭下拉菜单，防止与其他界面元素交互
    private var coverView: UIView?
    
    /// 下拉菜单是否已展开
    private var isOpened: Bool = false
    
    /// 缓存的下拉菜单高度（避免重复计算）
    private var cachedDropdownHeight: CGFloat = 0
    
    /// 缓存的选项总数（避免重复调用数据源）
    private var cachedOptionsCount: Int = 0
    
    /// 缓存的 KeyWindow（避免重复遍历）
    private weak var cachedKeyWindow: UIWindow?
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateFrames()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        updateFrames()
    }
    
    // MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !isOpened && bounds != containerView.bounds {
            updateFrames() // 仅在未展开且尺寸变化时更新布局
            updateMenuButtonBackground() // 更新按钮背景图片大小
        }
    }
    
    // MARK: - Public Methods
    
    /// 重新加载数据（当数据源更新时需要调用此方法刷新列表）
    public func reloadData() {
        // 清除缓存，强制重新计算
        cachedDropdownHeight = 0
        cachedOptionsCount = 0
        dropdownList.reloadData()
    }
    
    /// 展开下拉菜单
    public func open() {
        isOpened = true
        
        // 计算菜单位置
        let newPosition = convertToScreenPosition()
        containerView.frame = CGRect(
            x: newPosition.x,
            y: newPosition.y,
            width: containerView.bounds.width,
            height: containerView.bounds.height
        )
        
        // 更新浮动视图样式
        containerView.layer.borderColor = layer.borderColor
        containerView.layer.borderWidth = layer.borderWidth
        containerView.layer.cornerRadius = layer.cornerRadius
        getCoverView().addSubview(containerView)
        
        // 触发代理回调：将要展开
        delegate?.dropdownMenuWillAppear(self)
        
        // 刷新下拉数据
        reloadData()
        
        // 计算下拉菜单高度（使用缓存）
        let listHeight = calculateDropdownHeight()
        
        // 开始展开动画
        UIView.animate(withDuration: animationDuration, animations: {
            // 更新浮动视图 & 菜单列表高度
            var containerViewFrame = self.containerView.frame
            containerViewFrame.size.height = self.menuButton.frame.height + listHeight
            self.containerView.frame = containerViewFrame
            
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
            
            var listViewFrame = self.dropdownList.frame
            listViewFrame.size.height = listHeight
            self.dropdownList.frame = listViewFrame
            
        }) { [weak self] finished in
            guard let self = self else { return }
            // 触发代理回调：展开完成
            self.delegate?.dropdownMenuDidAppear(self)
        }
        
        menuButton.isSelected = true
    }
    
    /// 关闭下拉菜单
    @objc public func close() {
        // 1. 调用代理方法，通知即将关闭
        delegate?.dropdownMenuWillDisappear(self)
        
        // 2. 执行关闭动画
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            guard let self = self else { return }
            
            // 恢复箭头方向
            self.arrowImageView.transform = .identity
            
            // 收起 `containerView`
            self.containerView.frame = CGRect(
                x: self.containerView.frame.origin.x,
                y: self.containerView.frame.origin.y,
                width: self.containerView.frame.width,
                height: self.menuButton.frame.height
            )
            
        }) { [weak self] finished in
            guard let self = self else { return }
            
            // 3. 彻底收起 `dropdownList`
            self.dropdownList.frame = CGRect(
                x: self.dropdownList.frame.origin.x,
                y: self.dropdownList.frame.origin.y,
                width: self.frame.width,
                height: 0
            )
            
            // 4. 复原 `containerView`
            self.containerView.frame = self.containerView.bounds
            self.addSubview(self.containerView)
            
            // 5. 移除 `coverView`
            self.coverView?.removeFromSuperview()
            self.coverView = nil
            
            // 6. 更新状态
            self.isOpened = false
            
            // 7. 清除 KeyWindow 缓存（窗口可能已变化）
            self.cachedKeyWindow = nil
            
            // 8. 通知代理方法，菜单已经关闭
            self.delegate?.dropdownMenuDidDisappear(self)
        }
        
        // 9. 取消 `menuButton` 的选中状态
        menuButton.isSelected = false
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        layer.masksToBounds = true
        
        addSubview(containerView)
        containerView.addSubview(menuButton)
        menuButton.addSubview(arrowImageView)
        containerView.addSubview(dropdownList)
        
        // 设置默认背景色
        menuTitleBackgroundColor = UIColor(red: 64/255.0, green: 151/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    /// 更新视图的 Frame
    private func updateFrames() {
        let width = frame.width
        let height = frame.height
        
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        menuButton.frame = CGRect(x: 0, y: 0, width: width, height: height)
        arrowImageView.frame = CGRect(
            x: width - menuArrowIconMarginRight - menuArrowIconSize.width,
            y: (height - menuArrowIconSize.height) / 2,
            width: menuArrowIconSize.width,
            height: menuArrowIconSize.height
        )
        dropdownList.frame = CGRect(
            x: 0,
            y: height,
            width: width,
            height: dropdownList.frame.height
        )
    }
    
    /// 点击菜单按钮事件
    @objc private func clickMenuBtnAction(_ button: UIButton) {
        button.isSelected ? close() : open()
    }
    
    /// 计算下拉菜单高度（带缓存优化）
    private func calculateDropdownHeight() -> CGFloat {
        // 如果已缓存且数据源未变化，直接返回缓存值
        if cachedDropdownHeight > 0 && cachedOptionsCount > 0 {
            let currentCount = dataSource?.numberOfOptions(in: self) ?? 0
            if currentCount == cachedOptionsCount {
                return cachedDropdownHeight
            }
        }
        
        var listHeight: CGFloat = 0
        
        if optionsListMaxHeight <= 0 {
            // 当未设置最大高度时，根据内容计算
            let count = dataSource?.numberOfOptions(in: self) ?? 0
            cachedOptionsCount = count
            
            // 批量计算高度，减少方法调用开销
            for i in 0..<count {
                listHeight += dataSource?.dropdownMenu(self, optionHeightAt: i) ?? 0
            }
            dropdownList.isScrollEnabled = false
        } else {
            // 设置了最大高度时，使用该高度
            listHeight = optionsListMaxHeight
            cachedOptionsCount = dataSource?.numberOfOptions(in: self) ?? 0
            dropdownList.isScrollEnabled = true
        }
        
        // 缓存计算结果
        cachedDropdownHeight = listHeight
        
        return listHeight
    }
    
    /// 将当前视图的原点转换为屏幕坐标系中的位置
    private func convertToScreenPosition() -> CGPoint {
        guard let keyWindow = currentKeyWindow() else { return .zero }
        return superview?.convert(
            CGPoint(x: frame.minX, y: frame.minY),
            to: keyWindow
        ) ?? .zero
    }
    
    /// 获取当前 App 的 KeyWindow（兼容 iOS 13+，带缓存优化）
    private func currentKeyWindow() -> UIWindow? {
        // 如果缓存的 window 仍然有效，直接返回
        if let cached = cachedKeyWindow, cached.isKeyWindow {
            return cached
        }
        
        var foundWindow: UIWindow?
        
        // 遍历所有已连接的场景
        for scene in UIApplication.shared.connectedScenes {
            if let windowScene = scene as? UIWindowScene {
                for window in windowScene.windows {
                    if window.isKeyWindow {
                        cachedKeyWindow = window // 缓存结果
                        return window // 直接返回 keyWindow
                    }
                    
                    // 兜底方案，取第一个可见的 window
                    if foundWindow == nil && window.windowLevel == .normal {
                        foundWindow = window
                    }
                }
            }
        }
        
        // 缓存找到的 window（即使是兜底方案）
        if let found = foundWindow {
            cachedKeyWindow = found
        }
        
        return foundWindow // 兜底返回
    }
    
    /// 获取或创建 coverView
    private func getCoverView() -> UIView {
        if let cover = coverView {
            return cover
        }
        
        let cover = UIView(frame: UIScreen.main.bounds)
        cover.backgroundColor = .clear
        
        // 添加点击手势，点击时关闭菜单
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        tap.delegate = self
        cover.addGestureRecognizer(tap)
        
        // 添加到当前 KeyWindow
        currentKeyWindow()?.addSubview(cover)
        
        coverView = cover
        return cover
    }
    
    /// 更新按钮背景图片（当按钮大小改变时）
    private func updateMenuButtonBackground() {
        guard let backgroundColor = menuTitleBackgroundColor else { return }
        
        let buttonSize = menuButton.bounds.size
        let size = buttonSize == .zero ? CGSize(width: 100, height: 40) : buttonSize
        
        let backgroundImage = imageWithColor(backgroundColor, size: size)
        menuButton.setBackgroundImage(backgroundImage, for: .normal)
        menuButton.backgroundColor = .clear // 清除 backgroundColor，让背景图片生效
    }
    
    /// 将颜色转换为图片（用于按钮背景）
    private func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size == .zero ? CGSize(width: 1, height: 1) : size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
    /// 更新旋转图标（箭头）的 frame
    private func updateRotateIconFrame() {
        arrowImageView.frame = CGRect(
            x: menuButton.bounds.width - menuArrowIconMarginRight - menuArrowIconSize.width,
            y: (menuButton.bounds.height - menuArrowIconSize.height) / 2,
            width: menuArrowIconSize.width,
            height: menuArrowIconSize.height
        )
    }
    
    /// 统一封装 Cell 的内容配置
    private func configureCell(_ cell: ZHHDropdownMenuCell, at indexPath: IndexPath, for tableView: UITableView) {
        let row = indexPath.row
        
        // 使用缓存的总数判断是否为最后一行，避免重复调用数据源
        let totalCount = cachedOptionsCount > 0 ? cachedOptionsCount : (dataSource?.numberOfOptions(in: self) ?? 0)
        if cachedOptionsCount == 0 {
            cachedOptionsCount = totalCount
        }
        let isLastItem = row == totalCount - 1
        
        // 设置分割线的显示状态
        cell.separatorInset = isLastItem ? UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0) : separatorInsets
        
        let cHeight = dataSource?.dropdownMenu(self, optionHeightAt: row) ?? 0
        let cellWidth = tableView.bounds.width
        
        // 设置标题
        let title = dataSource?.dropdownMenu(self, optionTitleAt: row) ?? ""
        cell.titleLabel.text = title
        cell.titleLabel.font = optionTextFont
        cell.titleLabel.textColor = optionTextColor
        cell.titleLabel.numberOfLines = optionNumberOfLines
        cell.titleLabel.textAlignment = optionTextAlignment
        
        // 计算标题 frame
        let titleWidth = cellWidth - optionTextMarginLeft - optionIconSize.width - optionIconMarginRight
        cell.titleLabel.frame = CGRect(x: optionTextMarginLeft, y: 0, width: titleWidth, height: cHeight)
        
        // 设置图标（如果有）
        if let icon = dataSource?.dropdownMenu(self, optionIconAt: row) {
            cell.iconImageView.image = icon
        }
        
        // 计算图标 frame
        if optionIconSize.width > 0 && optionIconSize.height > 0 {
            let iconX = cellWidth - optionIconSize.width - optionIconMarginRight
            let iconY = (cHeight - optionIconSize.height) / 2
            cell.iconImageView.frame = CGRect(x: iconX, y: iconY, width: optionIconSize.width, height: optionIconSize.height)
            cell.iconImageView.isHidden = false
        } else {
            cell.iconImageView.isHidden = true
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension ZHHDropdownMenu: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfOptions(in: self) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource?.dropdownMenu(self, optionHeightAt: indexPath.row) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ZHHDropdownMenuCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ZHHDropdownMenuCell
            ?? ZHHDropdownMenuCell(style: .default, reuseIdentifier: cellIdentifier)
        
        // 配置 Cell
        configureCell(cell, at: indexPath, for: tableView)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 直接从数据源获取标题，避免获取 cell（cell 可能不在屏幕上）
        let selectedTitle = dataSource?.dropdownMenu(self, optionTitleAt: indexPath.row) ?? ""
        menuTitle = selectedTitle
        
        // 触发代理方法
        delegate?.dropdownMenu(self, didSelectOptionAt: indexPath.row, title: selectedTitle)
        
        close() // 关闭下拉菜单
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ZHHDropdownMenu: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass(type(of: touch.view!)) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
}

