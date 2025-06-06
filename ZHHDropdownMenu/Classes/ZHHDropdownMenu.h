//
//  ZHHDropdownMenu.h
//
//  Created by Jerry LMJ on 15/5/4.
//  Copyright (c) 2015年 LMJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHHDropdownMenu;

NS_ASSUME_NONNULL_BEGIN

/**
 * @protocol ZHHDropdownMenuDataSource
 * @brief 下拉菜单的数据源协议，提供菜单项的数量、高度、标题和可选的图标。
 */
@protocol ZHHDropdownMenuDataSource <NSObject>

@required

/// 获取下拉菜单的选项数量
/// @param menu 下拉菜单实例
/// @return 选项的总数
- (NSUInteger)numberOfOptionsInDropdownMenu:(ZHHDropdownMenu *)menu;
/// 获取指定索引选项的高度
/// @param menu 下拉菜单实例
/// @param index 选项索引（从 0 开始）
/// @return 该选项的高度（单位：points）
- (CGFloat)dropdownMenu:(ZHHDropdownMenu *)menu optionHeightAtIndex:(NSUInteger)index;

/// 获取指定索引选项的标题
/// @param menu 下拉菜单实例
/// @param index 选项索引（从 0 开始）
/// @return 该选项的文本标题
- (NSString *)dropdownMenu:(ZHHDropdownMenu *)menu optionTitleAtIndex:(NSUInteger)index;

@optional
/// 获取指定索引选项的图标（可选）
/// @param menu 下拉菜单实例
/// @param index 选项索引（从 0 开始）
/// @return 该选项对应的 UIImage 图标（可返回 nil）
- (UIImage *)dropdownMenu:(ZHHDropdownMenu *)menu optionIconAtIndex:(NSUInteger)index;
@end


@protocol ZHHDropdownMenuDelegate <NSObject>

@optional
/// 下拉菜单即将展开
- (void)dropdownMenuWillAppear:(ZHHDropdownMenu *)menu;

/// 下拉菜单已经展开
- (void)dropdownMenuDidAppear:(ZHHDropdownMenu *)menu;

/// 下拉菜单即将收起
- (void)dropdownMenuWillDisappear:(ZHHDropdownMenu *)menu;

/// 下拉菜单已经收起
- (void)dropdownMenuDidDisappear:(ZHHDropdownMenu *)menu;

/// 选中某个选项
- (void)dropdownMenu:(ZHHDropdownMenu *)menu didSelectOptionAtIndex:(NSUInteger)index title:(NSString *)title;

@end

@interface ZHHDropdownMenu : UIView

#pragma mark - DataSource & Delegate
/// 数据源代理，用于提供选项数据
@property (nonatomic, weak) id <ZHHDropdownMenuDataSource> dataSource;
/// 事件代理，用于监听菜单的展开、隐藏和选中事件
@property (nonatomic, weak) id <ZHHDropdownMenuDelegate> delegate;

#pragma mark - 标题相关（Title）
/// 下拉菜单的主标题文本
@property (nonatomic, copy) NSString *menuTitle;
/// 菜单标题的背景颜色（默认：白色）
@property (nonatomic, strong) UIColor *menuTitleBackgroundColor;
/// 菜单标题的字体（默认：系统字体 14 号）
@property (nonatomic, strong) UIFont *menuTitleFont;
/// 菜单标题的文字颜色（默认：黑色）
@property (nonatomic, strong) UIColor *menuTitleTextColor;
/// 菜单标题的文字对齐方式（默认：居中）
@property (nonatomic, assign) NSTextAlignment menuTitleAlignment;
/// 菜单标题的边距（默认为 UIEdgeInsetsZero，可用于调整内边距）
@property (nonatomic, assign) UIEdgeInsets menuTitleEdgeInsets;

#pragma mark - 旋转图标（Rotate Icon）

/// 右侧旋转箭头图标（通常用于指示下拉菜单状态）
@property (nonatomic, strong) UIImage *menuArrowIcon;
/// 旋转图标的大小（默认：CGSizeZero，需在外部赋值）
@property (nonatomic, assign) CGSize menuArrowIconSize;
/// 旋转图标距离右侧的间距（默认：7.5）
@property (nonatomic, assign) CGFloat menuArrowIconMarginRight;
/// 旋转图标的颜色（仅适用于可更改颜色的图片，如 `UIImageRenderingModeAlwaysTemplate`）
@property (nonatomic, strong) UIColor *menuArrowIconTintColor;

#pragma mark - 选项样式（Option Style）

/// 选项的背景颜色（默认：白色）
@property (nonatomic, strong) UIColor *optionBackgroundColor;
/// 选项的字体（默认：系统字体 14 号）
@property (nonatomic, strong) UIFont *optionTextFont;
/// 选项的文本颜色（默认：黑色）
@property (nonatomic, strong) UIColor *optionTextColor;
/// 选项文本的对齐方式（默认：左对齐）
@property (nonatomic, assign) NSTextAlignment optionTextAlignment;
/// 选项文本距离左侧的间距（默认：15）
@property (nonatomic, assign) CGFloat optionTextMarginLeft;
/// 选项文本的最大行数（默认：1，超过会自动截断）
@property (nonatomic, assign) NSInteger optionNumberOfLines;
/// 选项图标的大小（默认：CGSizeMake(15, 15)）
@property (nonatomic, assign) CGSize optionIconSize;
/// 选项图标距离右侧的间距（默认：15）
@property (nonatomic, assign) CGFloat optionIconMarginRight;
/// 选项之间分割线的颜色（默认：系统TableViewCell的颜色）
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, assign) UIEdgeInsets separatorInsets;

#pragma mark - 选项列表（Options List）

/// 选项列表的最大显示高度，超过此高度则会滚动
/// - 当 `optionsListMaxHeight <= 0` 时，菜单会展示所有选项，不受高度限制（默认值：0）
@property (nonatomic, assign) CGFloat optionsListMaxHeight;
/// 是否显示选项列表的垂直滚动条（默认：YES）
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;

#pragma mark - 动画相关（Animation）

/// 下拉动画的时长（默认：0.25 秒）
@property (nonatomic, assign) CGFloat animationDuration;

#pragma mark - 方法（Methods）

/// 重新加载数据（当数据源更新时需要调用此方法刷新列表）
- (void)reloadData;

/// 展开下拉菜单
- (void)open;
/// 关闭下拉菜单
- (void)close;

@end

NS_ASSUME_NONNULL_END
