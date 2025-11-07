//
//  ZHHViewController.m
//  ZHHDropdownMenu
//
//  Created by 桃色三岁 on 06/06/2025.
//  Copyright (c) 2025 桃色三岁. All rights reserved.
//

#import "ZHHViewController.h"
#import <ZHHDropdownMenu/ZHHDropdownMenu.h>

@interface ZHHViewController () <ZHHDropdownMenuDataSource, ZHHDropdownMenuDelegate>

// 示例1：基础菜单（商品类型）
@property (nonatomic, strong) ZHHDropdownMenu *menuView1;
@property (nonatomic, strong) NSArray *optionTitles1;

// 示例2：无图标菜单（城市选择）
@property (nonatomic, strong) ZHHDropdownMenu *menuView2;
@property (nonatomic, strong) NSArray *optionTitles2;

// 示例3：自定义样式菜单（排序方式）
@property (nonatomic, strong) ZHHDropdownMenu *menuView3;
@property (nonatomic, strong) NSArray *optionTitles3;

// 示例4：多行文本菜单（长文本选项）
@property (nonatomic, strong) ZHHDropdownMenu *menuView4;
@property (nonatomic, strong) NSArray *optionTitles4;

@end

@implementation ZHHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZHHDropdownMenu 示例";
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    
    // 初始化数据
    [self setupData];
    
    // 添加菜单视图
    [self setupMenus];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 在布局完成后设置位置，避免使用 center（在 viewDidLoad 中可能不准确）
    CGFloat spacing = 20;
    CGFloat menuHeight = 40;
    CGFloat startY = 100;
    
    self.menuView1.frame = CGRectMake(15, startY, 136, menuHeight);
    self.menuView2.frame = CGRectMake(15, startY + menuHeight + spacing, 150, menuHeight);
    self.menuView3.frame = CGRectMake(15, startY + (menuHeight + spacing) * 2, 120, menuHeight);
    self.menuView4.frame = CGRectMake(15, startY + (menuHeight + spacing) * 3, 200, menuHeight);
}

- (void)setupData {
    // 示例1：商品类型（带图标）
    self.optionTitles1 = @[
        @"日用品", @"食品", @"电子产品", @"个护化妆",
        @"家居用品", @"生鲜水果", @"母婴用品", @"宠物用品",
        @"服装鞋帽", @"图书文具"
    ];
    
    // 示例2：城市选择（无图标）
    self.optionTitles2 = @[
        @"北京", @"上海", @"广州", @"深圳",
        @"杭州", @"成都", @"武汉", @"西安"
    ];
    
    // 示例3：排序方式（自定义样式）
    self.optionTitles3 = @[
        @"综合排序", @"价格从低到高", @"价格从高到低",
        @"销量最高", @"最新上架"
    ];
    
    // 示例4：长文本选项（多行显示）
    self.optionTitles4 = @[
        @"这是一个很长的选项文本，用来测试多行显示效果",
        @"短文本",
        @"另一个超长的选项文本内容，用于展示当文本内容很长时，菜单如何自适应显示",
        @"普通选项"
    ];
}

- (void)setupMenus {
    [self.view addSubview:self.menuView1];
    [self.view addSubview:self.menuView2];
    [self.view addSubview:self.menuView3];
    [self.view addSubview:self.menuView4];
}

#pragma mark - ZHHDropdownMenu DataSource

- (NSUInteger)numberOfOptionsInDropdownMenu:(ZHHDropdownMenu *)menu {
    if (menu == self.menuView1) {
        return self.optionTitles1.count;
    } else if (menu == self.menuView2) {
        return self.optionTitles2.count;
    } else if (menu == self.menuView3) {
        return self.optionTitles3.count;
    } else if (menu == self.menuView4) {
        return self.optionTitles4.count;
    }
    return 0;
}

- (CGFloat)dropdownMenu:(ZHHDropdownMenu *)menu optionHeightAtIndex:(NSUInteger)index {
    // 示例4 使用更大的高度以支持多行文本
    if (menu == self.menuView4) {
        return 50;
    }
    return 40;
}

- (NSString *)dropdownMenu:(ZHHDropdownMenu *)menu optionTitleAtIndex:(NSUInteger)index {
    if (menu == self.menuView1) {
        return self.optionTitles1[index];
    } else if (menu == self.menuView2) {
        return self.optionTitles2[index];
    } else if (menu == self.menuView3) {
        return self.optionTitles3[index];
    } else if (menu == self.menuView4) {
        return self.optionTitles4[index];
    }
    return @"";
}

- (UIImage *)dropdownMenu:(ZHHDropdownMenu *)menu optionIconAtIndex:(NSUInteger)index {
    // 只有示例1和示例3显示图标
    if (menu == self.menuView1 || menu == self.menuView3) {
        return [UIImage imageNamed:@"icon_flame_small"];
    }
    return nil;
}

#pragma mark - ZHHDropdownMenu Delegate

- (void)dropdownMenuWillAppear:(ZHHDropdownMenu *)menu {
    NSString *menuName = [self menuNameForMenu:menu];
    NSLog(@"菜单即将展开: %@", menuName);
}

- (void)dropdownMenuDidAppear:(ZHHDropdownMenu *)menu {
    NSLog(@"菜单已展开");
}

- (void)dropdownMenuWillDisappear:(ZHHDropdownMenu *)menu {
    NSLog(@"菜单即将关闭");
}

- (void)dropdownMenuDidDisappear:(ZHHDropdownMenu *)menu {
    NSLog(@"菜单已关闭");
}

- (void)dropdownMenu:(ZHHDropdownMenu *)menu didSelectOptionAtIndex:(NSUInteger)index title:(NSString *)title {
    NSString *menuName = [self menuNameForMenu:menu];
    NSLog(@"【%@】选择了：index: %lu - title: %@", menuName, (unsigned long)index, title);
    
    // 可以在这里添加 UI 反馈，比如显示提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择结果"
                                                                   message:[NSString stringWithFormat:@"%@\n索引: %lu\n标题: %@", menuName, (unsigned long)index, title]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Helper Methods

- (NSString *)menuNameForMenu:(ZHHDropdownMenu *)menu {
    if (menu == self.menuView1) {
        return @"商品类型";
    } else if (menu == self.menuView2) {
        return @"城市选择";
    } else if (menu == self.menuView3) {
        return @"排序方式";
    } else if (menu == self.menuView4) {
        return @"长文本";
    }
    return @"未知";
}

#pragma mark - 懒加载菜单视图

// 示例1：基础菜单（商品类型）- 带图标，橙色主题
- (ZHHDropdownMenu *)menuView1 {
    if (!_menuView1) {
        _menuView1 = [[ZHHDropdownMenu alloc] initWithFrame:CGRectZero];
        _menuView1.dataSource = self;
        _menuView1.delegate = self;
        
        // 边框和圆角
        _menuView1.layer.borderColor = [UIColor systemOrangeColor].CGColor;
        _menuView1.layer.borderWidth = 1;
        _menuView1.layer.cornerRadius = 8;
        _menuView1.layer.masksToBounds = YES;
        
        // 标题样式
        _menuView1.menuTitle = @"商品类型";
        _menuView1.menuTitleBackgroundColor = [UIColor systemOrangeColor];
        _menuView1.menuTitleFont = [UIFont boldSystemFontOfSize:15];
        _menuView1.menuTitleTextColor = [UIColor whiteColor];
        _menuView1.menuTitleAlignment = NSTextAlignmentCenter;
        _menuView1.menuTitleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        
        // 箭头图标
        _menuView1.menuArrowIcon = [UIImage imageNamed:@"icon_arrow_down"];
        _menuView1.menuArrowIconSize = CGSizeMake(18, 18);
        _menuView1.menuArrowIconMarginRight = 10;
        _menuView1.menuArrowIconTintColor = [UIColor whiteColor];
        
        // 选项样式
        _menuView1.optionBackgroundColor = [UIColor whiteColor];
        _menuView1.optionTextFont = [UIFont systemFontOfSize:14];
        _menuView1.optionTextColor = [UIColor labelColor];
        _menuView1.optionTextAlignment = NSTextAlignmentLeft;
        _menuView1.optionTextMarginLeft = 15;
        _menuView1.optionNumberOfLines = 1;
        _menuView1.optionIconSize = CGSizeMake(15, 15);
        _menuView1.optionIconMarginRight = 15;
        
        // 分割线
        _menuView1.separatorColor = [UIColor systemGray5Color];
        _menuView1.separatorInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        
        // 列表最大高度（超过则滚动）
        _menuView1.optionsListMaxHeight = 200;
        _menuView1.showsVerticalScrollIndicator = YES;
        
        // 动画时长
        _menuView1.animationDuration = 0.25;
    }
    return _menuView1;
}

// 示例2：无图标菜单（城市选择）- 蓝色主题，无图标
- (ZHHDropdownMenu *)menuView2 {
    if (!_menuView2) {
        _menuView2 = [[ZHHDropdownMenu alloc] initWithFrame:CGRectZero];
        _menuView2.dataSource = self;
        _menuView2.delegate = self;
        
        // 边框和圆角
        _menuView2.layer.borderColor = [UIColor systemBlueColor].CGColor;
        _menuView2.layer.borderWidth = 1;
        _menuView2.layer.cornerRadius = 6;
        _menuView2.layer.masksToBounds = YES;
        
        // 标题样式
        _menuView2.menuTitle = @"选择城市";
        _menuView2.menuTitleBackgroundColor = [UIColor systemBlueColor];
        _menuView2.menuTitleFont = [UIFont systemFontOfSize:15];
        _menuView2.menuTitleTextColor = [UIColor whiteColor];
        _menuView2.menuTitleAlignment = NSTextAlignmentLeft;
        _menuView2.menuTitleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);
        
        // 箭头图标
        _menuView2.menuArrowIcon = [UIImage imageNamed:@"icon_arrow_down"];
        _menuView2.menuArrowIconSize = CGSizeMake(16, 16);
        _menuView2.menuArrowIconMarginRight = 12;
        _menuView2.menuArrowIconTintColor = [UIColor whiteColor];
        
        // 选项样式（无图标）
        _menuView2.optionBackgroundColor = [UIColor whiteColor];
        _menuView2.optionTextFont = [UIFont systemFontOfSize:14];
        _menuView2.optionTextColor = [UIColor labelColor];
        _menuView2.optionTextAlignment = NSTextAlignmentLeft;
        _menuView2.optionTextMarginLeft = 15;
        _menuView2.optionIconSize = CGSizeMake(0, 0); // 不显示图标
        
        // 分割线
        _menuView2.separatorColor = [UIColor systemGray5Color];
        _menuView2.separatorInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        
        // 列表最大高度
        _menuView2.optionsListMaxHeight = 160;
    }
    return _menuView2;
}

// 示例3：自定义样式菜单（排序方式）- 绿色主题，小尺寸
- (ZHHDropdownMenu *)menuView3 {
    if (!_menuView3) {
        _menuView3 = [[ZHHDropdownMenu alloc] initWithFrame:CGRectZero];
        _menuView3.dataSource = self;
        _menuView3.delegate = self;
        
        // 边框和圆角
        _menuView3.layer.borderColor = [UIColor systemGreenColor].CGColor;
        _menuView3.layer.borderWidth = 1;
        _menuView3.layer.cornerRadius = 5;
        _menuView3.layer.masksToBounds = YES;
        
        // 标题样式
        _menuView3.menuTitle = @"排序";
        _menuView3.menuTitleBackgroundColor = [UIColor systemGreenColor];
        _menuView3.menuTitleFont = [UIFont systemFontOfSize:13];
        _menuView3.menuTitleTextColor = [UIColor whiteColor];
        _menuView3.menuTitleAlignment = NSTextAlignmentCenter;
        _menuView3.menuTitleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        
        // 箭头图标
        _menuView3.menuArrowIcon = [UIImage imageNamed:@"icon_arrow_down"];
        _menuView3.menuArrowIconSize = CGSizeMake(14, 14);
        _menuView3.menuArrowIconMarginRight = 8;
        _menuView3.menuArrowIconTintColor = [UIColor whiteColor];
        
        // 选项样式
        _menuView3.optionBackgroundColor = [UIColor whiteColor];
        _menuView3.optionTextFont = [UIFont systemFontOfSize:13];
        _menuView3.optionTextColor = [UIColor labelColor];
        _menuView3.optionTextAlignment = NSTextAlignmentLeft;
        _menuView3.optionTextMarginLeft = 12;
        _menuView3.optionIconSize = CGSizeMake(12, 12);
        _menuView3.optionIconMarginRight = 10;
        
        // 分割线
        _menuView3.separatorColor = [UIColor systemGray5Color];
        _menuView3.separatorInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        
        // 列表最大高度
        _menuView3.optionsListMaxHeight = 200;
    }
    return _menuView3;
}

// 示例4：多行文本菜单（长文本选项）- 紫色主题，支持多行
- (ZHHDropdownMenu *)menuView4 {
    if (!_menuView4) {
        _menuView4 = [[ZHHDropdownMenu alloc] initWithFrame:CGRectZero];
        _menuView4.dataSource = self;
        _menuView4.delegate = self;
        
        // 边框和圆角
        _menuView4.layer.borderColor = [UIColor systemPurpleColor].CGColor;
        _menuView4.layer.borderWidth = 1;
        _menuView4.layer.cornerRadius = 8;
        _menuView4.layer.masksToBounds = YES;
        
        // 标题样式
        _menuView4.menuTitle = @"长文本选项";
        _menuView4.menuTitleBackgroundColor = [UIColor systemPurpleColor];
        _menuView4.menuTitleFont = [UIFont systemFontOfSize:15];
        _menuView4.menuTitleTextColor = [UIColor whiteColor];
        _menuView4.menuTitleAlignment = NSTextAlignmentLeft;
        _menuView4.menuTitleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);
        
        // 箭头图标
        _menuView4.menuArrowIcon = [UIImage imageNamed:@"icon_arrow_down"];
        _menuView4.menuArrowIconSize = CGSizeMake(16, 16);
        _menuView4.menuArrowIconMarginRight = 12;
        _menuView4.menuArrowIconTintColor = [UIColor whiteColor];
        
        // 选项样式（支持多行）
        _menuView4.optionBackgroundColor = [UIColor whiteColor];
        _menuView4.optionTextFont = [UIFont systemFontOfSize:14];
        _menuView4.optionTextColor = [UIColor labelColor];
        _menuView4.optionTextAlignment = NSTextAlignmentLeft;
        _menuView4.optionTextMarginLeft = 15;
        _menuView4.optionNumberOfLines = 0; // 0 表示不限制行数
        _menuView4.optionIconSize = CGSizeMake(0, 0); // 长文本时不显示图标
        
        // 分割线
        _menuView4.separatorColor = [UIColor systemGray5Color];
        _menuView4.separatorInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        
        // 列表最大高度
        _menuView4.optionsListMaxHeight = 200;
    }
    return _menuView4;
}

@end
