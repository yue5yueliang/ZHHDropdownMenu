//
//  ZHHDropdownMenu.m
//  ZHHDropdownMenu
//
//  Created by 桃色三岁 on 2025/3/24.
//  Copyright © 2025 桃色三岁. All rights reserved.
//

#import "ZHHDropdownMenu.h"
#import "ZHHDropdownMenuCell.h"

@interface ZHHDropdownMenu() <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView      *coverView;

@property (nonatomic, strong) UIButton    *menuButton;      ///< 主要的菜单按钮，点击后展开或收起下拉列表
@property (nonatomic, strong) UIImageView *arrowImageView;  ///< 下拉菜单的箭头指示图标，表示展开或收起状态
@property (nonatomic, strong) UITableView *dropdownList;    ///< 下拉菜单的选项列表

@property (nonatomic, strong) UIView      *containerView;  ///< 悬浮的菜单容器视图，包含 `dropdownList`，用于显示下拉菜单
@property (nonatomic, strong) UIView      *backgroundMask;  ///< 遮罩视图，点击遮罩可关闭下拉菜单，防止与其他界面元素交互

/// 下拉菜单是否已展开
@property (nonatomic, assign) BOOL isOpened;

/// 缓存的下拉菜单高度（避免重复计算）
@property (nonatomic, assign) CGFloat cachedDropdownHeight;
/// 缓存的选项总数（避免重复调用数据源）
@property (nonatomic, assign) NSUInteger cachedOptionsCount;
/// 缓存的 KeyWindow（避免重复遍历）
@property (nonatomic, weak) UIWindow *cachedKeyWindow;
@end



@implementation ZHHDropdownMenu


#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initProperties];  // 初始化默认属性
        [self setupUI];         // 初始化 UI 组件
        [self updateFrames];    // 设置初始 Frame
    }
    return self;
}

/// 视图布局更新
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.isOpened && !CGRectEqualToRect(self.bounds, self.containerView.bounds)) {
        [self updateFrames]; // 仅在未展开且尺寸变化时更新布局
        // 更新按钮背景图片大小
        [self updateButtonBackgroundImageIfNeeded];
    }
}

/// 更新按钮背景图片（当按钮大小改变时）
- (void)updateButtonBackgroundImageIfNeeded {
    if (!self.menuButton || !self.menuTitleBackgroundColor) {
        return;
    }
    
    CGSize buttonSize = self.menuButton.bounds.size;
    if (CGSizeEqualToSize(buttonSize, CGSizeZero)) {
        return;
    }
    
    UIImage *backgroundImage = [self imageWithColor:self.menuTitleBackgroundColor size:buttonSize];
    [self.menuButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}


#pragma mark - 初始化默认属性
/// 设置默认参数
- (void)initProperties {
    // 标题属性
    self.menuTitle = @"请选择";
    self.menuTitleBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:1];
    self.menuTitleFont = [UIFont boldSystemFontOfSize:15];
    self.menuTitleTextColor = [UIColor whiteColor];
    self.menuTitleAlignment = NSTextAlignmentLeft;
    self.menuTitleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);

    // 旋转箭头
    self.menuArrowIcon = nil;
    self.menuArrowIconSize = CGSizeMake(15, 15);
    self.menuArrowIconMarginRight = 7.5;
    self.menuArrowIconTintColor = [UIColor blackColor];

    // 选项属性
    _optionBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
    _optionTextFont = [UIFont systemFontOfSize:13];
    _optionTextColor = [UIColor blackColor];
    _optionTextAlignment = NSTextAlignmentCenter;
    _optionTextMarginLeft = 15;
    _optionNumberOfLines = 0;
    _optionIconSize = CGSizeMake(0, 0);
    _optionIconMarginRight = 15;

    // 动画 & 布局
    _animationDuration = 0.25f;
    _optionsListMaxHeight = 0;
    _isOpened = NO;
    _cachedDropdownHeight = 0;
    _cachedOptionsCount = 0;
    _cachedKeyWindow = nil;
}

#pragma mark - 初始化 UI
/// 初始化 UI 组件
- (void)setupUI {
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.menuButton];
    [self.menuButton addSubview:self.arrowImageView];
    [self.containerView addSubview:self.dropdownList];

    self.arrowImageView.tintColor = self.menuArrowIconTintColor;
}

/// 更新视图的 Frame
- (void)updateFrames {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;

    self.containerView.frame = CGRectMake(0, 0, width, height);
    self.menuButton.frame = CGRectMake(0, 0, width, height);
    self.arrowImageView.frame = CGRectMake(width - self.menuArrowIconMarginRight - self.menuArrowIconSize.width,
                                           (height - self.menuArrowIconSize.height) / 2,
                                           self.menuArrowIconSize.width, self.menuArrowIconSize.height);
    self.dropdownList.frame = CGRectMake(0, height, width, self.dropdownList.frame.size.height);
}

#pragma mark - Action Methods
/// 刷新下拉列表数据
- (void)reloadData {
    // 清除缓存，强制重新计算
    _cachedDropdownHeight = 0;
    _cachedOptionsCount = 0;
    [self.dropdownList reloadData];
}

/// 点击菜单按钮事件
- (void)clickMenuBtnAction:(UIButton *)button {
    button.selected ? [self close] : [self open];
}

/// 展开下拉菜单
- (void)open {
    self.isOpened = YES;
    
    // 计算菜单位置
    CGPoint newPosition = [self convertToScreenPosition];
    self.containerView.frame = CGRectMake(newPosition.x, newPosition.y, CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.containerView.bounds));
    
        // 更新浮动视图样式
        self.containerView.layer.borderColor  = self.layer.borderColor;
        self.containerView.layer.borderWidth  = self.layer.borderWidth;
        self.containerView.layer.cornerRadius = self.layer.cornerRadius;
        [self.coverView addSubview:self.containerView];

    // 触发代理回调：将要展开
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillAppear:)]) {
        [self.delegate dropdownMenuWillAppear:self];
    }

    // 刷新下拉数据
    [self reloadData];

    // 计算下拉菜单高度（使用缓存）
    CGFloat listHeight = [self calculateDropdownHeight];

    // 开始展开动画
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.animationDuration animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;

        // 更新浮动视图 & 菜单列表高度
        CGRect containerViewFrame = strongSelf.containerView.frame;
        containerViewFrame.size.height = CGRectGetHeight(strongSelf.menuButton.frame) + listHeight;
        strongSelf.containerView.frame = containerViewFrame;
        
        strongSelf.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        
        CGRect listViewFrame = strongSelf.dropdownList.frame;
        listViewFrame.size.height = listHeight;
        strongSelf.dropdownList.frame = listViewFrame;
        
    } completion:^(BOOL finished) {
        if (!weakSelf) return;
        // 触发代理回调：展开完成
        if ([weakSelf.delegate respondsToSelector:@selector(dropdownMenuDidAppear:)]) {
            [weakSelf.delegate dropdownMenuDidAppear:weakSelf];
        }
    }];

    self.menuButton.selected = YES;
}

/// 计算下拉菜单高度
- (CGFloat)calculateDropdownHeight {
    // 如果已缓存且数据源未变化，直接返回缓存值
    if (_cachedDropdownHeight > 0 && _cachedOptionsCount > 0) {
        NSUInteger currentCount = [self.dataSource numberOfOptionsInDropdownMenu:self];
        if (currentCount == _cachedOptionsCount) {
            return _cachedDropdownHeight;
        }
    }
    
    CGFloat listHeight = 0;
    
    if (self.optionsListMaxHeight <= 0) {
        // 当未设置最大高度时，根据内容计算
        NSUInteger count = [self.dataSource numberOfOptionsInDropdownMenu:self];
        _cachedOptionsCount = count;
        
        // 批量计算高度，减少方法调用开销
        for (NSUInteger i = 0; i < count; i++) {
            listHeight += [self.dataSource dropdownMenu:self optionHeightAtIndex:i];
        }
        self.dropdownList.scrollEnabled = NO;
    } else {
        // 设置了最大高度时，使用该高度
        listHeight = self.optionsListMaxHeight;
        _cachedOptionsCount = [self.dataSource numberOfOptionsInDropdownMenu:self];
        self.dropdownList.scrollEnabled = YES;
    }
    
    // 缓存计算结果
    _cachedDropdownHeight = listHeight;
    
    return listHeight;
}


/// 关闭下拉列表，并执行动画
- (void)close {
    // 1. 调用代理方法，通知即将关闭
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillDisappear:)]) {
        [self.delegate dropdownMenuWillDisappear:self];
    }

    // 2. 执行关闭动画
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.animationDuration animations:^{
        if (!weakSelf) return;

        // 恢复箭头方向
        weakSelf.arrowImageView.transform = CGAffineTransformIdentity;
        
        // 收起 `containerView`
        weakSelf.containerView.frame = CGRectMake(
            weakSelf.containerView.frame.origin.x,
            weakSelf.containerView.frame.origin.y,
            weakSelf.containerView.frame.size.width,
            weakSelf.menuButton.frame.size.height
        );
        
    } completion:^(BOOL finished) {
        if (!weakSelf) return;

        // 3. 彻底收起 `dropdownList`
        weakSelf.dropdownList.frame = CGRectMake(
            weakSelf.dropdownList.frame.origin.x,
            weakSelf.dropdownList.frame.origin.y,
            weakSelf.frame.size.width,
            0
        );

        // 4. 复原 `containerView`
        weakSelf.containerView.frame = weakSelf.containerView.bounds;
        [weakSelf addSubview:weakSelf.containerView];

        // 5. 移除 `coverView`
        [weakSelf.coverView removeFromSuperview];
        weakSelf.coverView = nil;

        // 6. 更新状态
        weakSelf.isOpened = NO;
        
        // 7. 清除 KeyWindow 缓存（窗口可能已变化）
        weakSelf.cachedKeyWindow = nil;

        // 8. 通知代理方法，菜单已经关闭
        if ([weakSelf.delegate respondsToSelector:@selector(dropdownMenuDidDisappear:)]) {
            [weakSelf.delegate dropdownMenuDidDisappear:weakSelf];
        }
    }];
    
    // 9. 取消 `menuButton` 的选中状态
    self.menuButton.selected = NO;
}

/// 将当前视图的原点转换为屏幕坐标系中的位置
- (CGPoint)convertToScreenPosition {
    UIWindow *keyWindow = [self currentKeyWindow];
    if (!keyWindow) return CGPointZero;
    
    return [self.superview convertPoint:CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)) toView:keyWindow];
}

/// 获取当前 App 的 KeyWindow（兼容 iOS 13+，带缓存优化）
- (UIWindow *)currentKeyWindow {
    // 如果缓存的 window 仍然有效，直接返回
    if (_cachedKeyWindow && _cachedKeyWindow.isKeyWindow) {
        return _cachedKeyWindow;
    }
    
    UIWindow *foundWindow = nil;
    
    // 遍历所有已连接的场景
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            
            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    _cachedKeyWindow = window; // 缓存结果
                    return window; // 直接返回 keyWindow
                }
                
                // 兜底方案，取第一个可见的 window
                if (!foundWindow && window.windowLevel == UIWindowLevelNormal) {
                    foundWindow = window;
                }
            }
        }
    }
    
    // 缓存找到的 window（即使是兜底方案）
    if (foundWindow) {
        _cachedKeyWindow = foundWindow;
    }
    
    return foundWindow; // 兜底返回
}

#pragma mark - UITableView DataSource & Delegate

// 获取下拉菜单的选项数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfOptionsInDropdownMenu:self];
}

// 获取每个选项的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource dropdownMenu:self optionHeightAtIndex:indexPath.row];
}

// 创建 & 配置 Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ZHHDropdownMenuCell";
    
    ZHHDropdownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZHHDropdownMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // 配置 Cell
    [self configureCell:cell atIndexPath:indexPath forTableView:tableView];

    return cell;
}

// 选中某个选项
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 直接从数据源获取标题，避免获取 cell（cell 可能不在屏幕上）
    NSString *selectedTitle = [self.dataSource dropdownMenu:self optionTitleAtIndex:indexPath.row];
    self.menuTitle = selectedTitle;

    // 触发代理方法
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectOptionAtIndex:title:)]) {
        [self.delegate dropdownMenu:self didSelectOptionAtIndex:indexPath.row title:selectedTitle];
    }

    [self close]; // 关闭下拉菜单
}


#pragma mark - Private Helper Methods

// 统一封装 Cell 的内容配置
- (void)configureCell:(ZHHDropdownMenuCell *)cell atIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView {
    NSUInteger row = indexPath.row;
    
    // 使用缓存的总数判断是否为最后一行，避免重复调用数据源
    NSUInteger totalCount = _cachedOptionsCount > 0 ? _cachedOptionsCount : [self.dataSource numberOfOptionsInDropdownMenu:self];
    if (_cachedOptionsCount == 0) {
        _cachedOptionsCount = totalCount;
    }
    BOOL isLastItem = (row == totalCount - 1);
    
    // 设置分割线的显示状态
    // 如果是最后一行，隐藏分割线
    // 否则，保持正常的分割线显示
    cell.separatorInset = isLastItem ? UIEdgeInsetsMake(0, CGRectGetWidth(tableView.bounds), 0, 0) : self.separatorInsets;
    
    CGFloat cHeight = [self.dataSource dropdownMenu:self optionHeightAtIndex:row];
    CGFloat cellWidth = CGRectGetWidth(tableView.bounds);

    // 设置标题（批量设置属性，减少多次属性访问）
    NSString *title = [self.dataSource dropdownMenu:self optionTitleAtIndex:row];
    cell.titleLabel.text = title;
    cell.titleLabel.font = self.optionTextFont;
    cell.titleLabel.textColor = self.optionTextColor;
    cell.titleLabel.numberOfLines = self.optionNumberOfLines;
    cell.titleLabel.textAlignment = self.optionTextAlignment;
    
    // 计算标题 frame
    CGFloat titleWidth = cellWidth - self.optionTextMarginLeft - self.optionIconSize.width - self.optionIconMarginRight;
    cell.titleLabel.frame = CGRectMake(self.optionTextMarginLeft, 0, titleWidth, cHeight);

    // 设置图标（如果有）
    if ([self.dataSource respondsToSelector:@selector(dropdownMenu:optionIconAtIndex:)]) {
        cell.iconImageView.image = [self.dataSource dropdownMenu:self optionIconAtIndex:row];
    }
    
    // 计算图标 frame
    if (self.optionIconSize.width > 0 && self.optionIconSize.height > 0) {
        CGFloat iconX = cellWidth - self.optionIconSize.width - self.optionIconMarginRight;
        CGFloat iconY = (cHeight - self.optionIconSize.height) * 0.5;
        cell.iconImageView.frame = CGRectMake(iconX, iconY, self.optionIconSize.width, self.optionIconSize.height);
        cell.iconImageView.hidden = NO;
    } else {
        cell.iconImageView.hidden = YES;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
   if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
       return NO;
   }
   return  YES;
}

#pragma mark - Get Methods

/// 获取是否显示垂直滚动条
- (BOOL)showsVerticalScrollIndicator {
    return self.dropdownList.showsVerticalScrollIndicator;
}

/// 懒加载 `coverView`，用于遮挡背景，点击后关闭下拉菜单
- (UIView *)coverView {
    if (!_coverView) {
        // 使用屏幕尺寸初始化，避免 `window` 为空导致的异常
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor clearColor];

        // 添加点击手势，点击时关闭菜单
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        tap.delegate = self;
        [_coverView addGestureRecognizer:tap];

        // 添加到当前 `KeyWindow`
        [[self currentKeyWindow] addSubview:_coverView];
    }
    return _coverView;
}

#pragma mark - Set Methods

/// 设置旋转图标（箭头）
- (void)setMenuArrowIcon:(UIImage *)menuArrowIcon {
    _menuArrowIcon = menuArrowIcon;
    
    if (menuArrowIcon) {
        self.arrowImageView.image = menuArrowIcon;
    } else {
        self.arrowImageView.image = nil; // 可省略，但加上更安全
    }
}

/// 设置旋转图标的尺寸
- (void)settMenuArrowIconSize:(CGSize)menuArrowIconSize {
    _menuArrowIconSize = menuArrowIconSize;
    [self updateRotateIconFrame]; // 更新箭头位置
}

/// 设置旋转图标的右边距
- (void)settMenuArrowIconMarginRight:(CGFloat)menuArrowIconMarginRight {
    _menuArrowIconMarginRight = menuArrowIconMarginRight;
    [self updateRotateIconFrame]; // 更新箭头位置
}

/// 更新旋转图标（箭头）的 `frame`
- (void)updateRotateIconFrame {
    self.arrowImageView.frame = CGRectMake(
        self.menuButton.bounds.size.width - self.menuArrowIconMarginRight - self.menuArrowIconSize.width,
        (self.menuButton.bounds.size.height - self.menuArrowIconSize.height) / 2,
        self.menuArrowIconSize.width,
        self.menuArrowIconSize.height
    );
}

/// 设置旋转图标的 `tintColor`
- (void)setMenuArrowIconTintColor:(UIColor *)menuArrowIconTintColor {
    _menuArrowIconTintColor = menuArrowIconTintColor;
    self.arrowImageView.tintColor = menuArrowIconTintColor;
}

/// 设置菜单标题
- (void)setMenuTitle:(NSString *)menuTitle {
    _menuTitle = [menuTitle copy];
    [self.menuButton setTitle:menuTitle forState:UIControlStateNormal];
}

/// 设置菜单标题的背景色
- (void)setMenuTitleBackgroundColor:(UIColor *)menuTitleBackgroundColor {
    _menuTitleBackgroundColor = menuTitleBackgroundColor;
    if (self.menuButton && menuTitleBackgroundColor) {
        CGSize buttonSize = self.menuButton.bounds.size;
        if (CGSizeEqualToSize(buttonSize, CGSizeZero)) {
            buttonSize = CGSizeMake(100, 40); // 默认大小，稍后会在 layoutSubviews 中更新
        }
        UIImage *backgroundImage = [self imageWithColor:menuTitleBackgroundColor size:buttonSize];
        [self.menuButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        self.menuButton.backgroundColor = [UIColor clearColor]; // 清除 backgroundColor，让背景图片生效
    }
}

/// 将颜色转换为图片（用于按钮背景）
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(1, 1);
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/// 设置菜单标题的字体
- (void)setMenuTitleFont:(UIFont *)menuTitleFont {
    _menuTitleFont = menuTitleFont;
    self.menuButton.titleLabel.font = menuTitleFont;
    [self.menuButton setNeedsLayout]; // 触发 UI 重新布局
}

/// 设置菜单标题的颜色
- (void)setMenuTitleTextColor:(UIColor *)menuTitleTextColor {
    _menuTitleTextColor = menuTitleTextColor;
    [self.menuButton setTitleColor:menuTitleTextColor forState:UIControlStateNormal];
    [self.menuButton setNeedsLayout]; // 触发 UI 重新布局
}

/// 设置菜单标题的对齐方式
- (void)setMenuTitleAlignment:(NSTextAlignment)menuTitleAlignment {
    _menuTitleAlignment = menuTitleAlignment;

    UIControlContentHorizontalAlignment alignment;
    switch (menuTitleAlignment) {
        case NSTextAlignmentLeft:
            alignment = UIControlContentHorizontalAlignmentLeft;
            break;
        case NSTextAlignmentCenter:
            alignment = UIControlContentHorizontalAlignmentCenter;
            break;
        case NSTextAlignmentRight:
            alignment = UIControlContentHorizontalAlignmentRight;
            break;
        default:
            alignment = UIControlContentHorizontalAlignmentCenter;
            break;
    }

    self.menuButton.contentHorizontalAlignment = alignment;
    [self.menuButton setNeedsLayout]; // 触发 UI 重新布局
}

/// 设置菜单标题的 `EdgeInsets`
- (void)setMenuTitleEdgeInsets:(UIEdgeInsets)menuTitleEdgeInsets {
    _menuTitleEdgeInsets = menuTitleEdgeInsets;
    self.menuButton.titleEdgeInsets = menuTitleEdgeInsets;
    [self.menuButton setNeedsLayout]; // 触发 UI 重新布局
}

/// 设置是否显示 `UITableView` 的垂直滚动条
- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator {
    self.dropdownList.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
}

#pragma mark - 懒加载视图
/// 容器视图
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

/// 下拉菜单按钮
- (UIButton *)menuButton {
    if (!_menuButton) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _menuButton.titleEdgeInsets = self.menuTitleEdgeInsets;
        [_menuButton setTitle:self.menuTitle forState:UIControlStateNormal];
        [_menuButton setTitleColor:self.menuTitleTextColor forState:UIControlStateNormal];
        _menuButton.titleLabel.font = self.menuTitleFont;
        
        // 使用背景图片方式设置背景色
        if (self.menuTitleBackgroundColor) {
            CGSize buttonSize = CGSizeMake(100, 40); // 初始默认大小，稍后会在 layoutSubviews 中更新
            UIImage *backgroundImage = [self imageWithColor:self.menuTitleBackgroundColor size:buttonSize];
            [_menuButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
            _menuButton.backgroundColor = [UIColor clearColor]; // 清除 backgroundColor，让背景图片生效
        }
        
        [_menuButton addTarget:self action:@selector(clickMenuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuButton;
}

/// 旋转箭头图标
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowImageView;
}

/// 下拉列表
- (UITableView *)dropdownList {
    if (!_dropdownList) {
        _dropdownList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _dropdownList.delegate       = self;
        _dropdownList.dataSource     = self;
        _dropdownList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _dropdownList.separatorColor = self.separatorColor;
        _dropdownList.separatorInset = self.separatorInsets;
        _dropdownList.scrollEnabled  = NO;
        
        // 减少不必要的视图更新
        _dropdownList.estimatedRowHeight = 0; // 禁用估算高度，使用精确高度
        _dropdownList.estimatedSectionHeaderHeight = 0;
        _dropdownList.estimatedSectionFooterHeight = 0;
        
        // 优化滚动性能
        _dropdownList.delaysContentTouches = NO; // 减少触摸延迟
        _dropdownList.canCancelContentTouches = YES;
    }
    return _dropdownList;
}

@end
