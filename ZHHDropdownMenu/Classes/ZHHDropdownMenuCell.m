//
//  ZHHDropdownMenuCell.m
//  ZHHDropdownMenu
//
//  Created by 桃色三岁 on 2025/3/24.
//  Copyright © 2025 桃色三岁. All rights reserved.
//

#import "ZHHDropdownMenuCell.h"

@interface ZHHDropdownMenuCell ()
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UIImageView *iconImageView;
@end

@implementation ZHHDropdownMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    // 重置 cell 状态，避免重用时的显示问题
    self.titleLabel.text = nil;
    self.iconImageView.image = nil;
    self.iconImageView.hidden = NO;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        // 允许选中高亮效果
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.iconImageView];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        // 移除不必要的 tag，使用属性访问更清晰
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.opaque = NO; // 优化渲染性能
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        // 移除不必要的 tag，使用属性访问更清晰
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.opaque = NO; // 优化渲染性能
    }
    return _iconImageView;
}
@end
