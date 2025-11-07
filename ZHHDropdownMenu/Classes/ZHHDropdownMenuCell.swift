//
//  ZHHDropdownMenuCell.swift
//  ZHHDropdownMenu
//
//  Created by 桃色三岁 on 2025/3/24.
//  Copyright © 2025 桃色三岁. All rights reserved.
//

import UIKit

/// 下拉菜单选项 Cell
public class ZHHDropdownMenuCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    /// 标题标签
    public private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.backgroundColor = .clear
        label.isOpaque = false // 优化渲染性能
        return label
    }()
    
    /// 图标视图
    public private(set) lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.isOpaque = false // 优化渲染性能
        return imageView
    }()
    
    // MARK: - Initialization
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        // 重置 cell 状态，避免重用时的显示问题
        titleLabel.text = nil
        iconImageView.image = nil
        iconImageView.isHidden = false
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .default // 允许选中高亮效果
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
    }
}

