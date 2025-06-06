//
//  ZHHViewController.m
//  ZHHDropdownMenu
//
//  Created by 桃色三岁 on 06/06/2025.
//  Copyright (c) 2025 桃色三岁. All rights reserved.
//

#import "ZHHViewController.h"
#import <ZHHDropdownMenu/ZHHDropdownMenu.h>

@interface ZHHViewController () <ZHHDropdownMenuDataSource,ZHHDropdownMenuDelegate>

@property (nonatomic, strong)ZHHDropdownMenu * menuView;
@property (nonatomic, strong)NSArray * optionTitles;
@property (nonatomic, strong)NSArray * optionIcons;

@end

@implementation ZHHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.optionTitles = @[
        @"日用品", @"食品", @"电子产品", @"个护化妆",
        @"家居用品", @"生鲜水果", @"母婴用品", @"宠物用品",
        @"服装鞋帽", @"图书文具"
    ];
    [self.view addSubview:self.menuView];
    self.menuView.center = self.view.center;
}

#pragma mark - ZHHDropdownMenu DataSource
- (NSUInteger)numberOfOptionsInDropdownMenu:(ZHHDropdownMenu *)menu{
    return self.optionTitles.count;
}

- (CGFloat)dropdownMenu:(ZHHDropdownMenu *)menu optionHeightAtIndex:(NSUInteger)index{
    return 40;
}

- (NSString *)dropdownMenu:(ZHHDropdownMenu *)menu optionTitleAtIndex:(NSUInteger)index{
    return self.optionTitles[index];
}

- (UIImage *)dropdownMenu:(ZHHDropdownMenu *)menu optionIconAtIndex:(NSUInteger)index{
    return [UIImage imageNamed:@"icon_flame_small"];
}

#pragma mark - ZHHDropdownMenu Delegate
- (void)dropdownMenu:(ZHHDropdownMenu *)menu didSelectOptionAtIndex:(NSUInteger)index title:(NSString *)title{
    NSLog(@"你选择了：menu，index: %ld - title: %@", index, title);
}

- (ZHHDropdownMenu *)menuView {
    if (!_menuView) {
        _menuView = [[ZHHDropdownMenu alloc] initWithFrame:CGRectMake(15, 15, 136, 40)];
        _menuView.dataSource = self;
        _menuView.delegate   = self;
        
        _menuView.layer.borderColor = UIColor.orangeColor.CGColor;
        _menuView.layer.borderWidth = 1;
        _menuView.layer.cornerRadius = 3;
        _menuView.layer.masksToBounds = YES;

        _menuView.menuTitle           = @"商品类型";
        _menuView.menuTitleBackgroundColor    = UIColor.orangeColor;
        _menuView.menuTitleFont       = [UIFont systemFontOfSize:15];
        _menuView.menuTitleTextColor  = UIColor.whiteColor;
        _menuView.menuTitleAlignment  = NSTextAlignmentCenter;
        _menuView.menuTitleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _menuView.menuArrowIcon      = [UIImage imageNamed:@"icon_arrow_down"];
        _menuView.menuArrowIconSize  = CGSizeMake(18, 18);
        
        _menuView.optionBackgroundColor = UIColor.whiteColor;
        _menuView.optionTextFont        = [UIFont systemFontOfSize:13];
        _menuView.optionTextColor       = UIColor.labelColor;
        _menuView.optionTextAlignment   = NSTextAlignmentLeft;
        _menuView.optionNumberOfLines   = 0;
        _menuView.optionIconSize        = CGSizeMake(15, 15);
        _menuView.optionIconMarginRight = 15;
        _menuView.optionsListMaxHeight = 36 * 5;
    }
    return _menuView;
}

@end
