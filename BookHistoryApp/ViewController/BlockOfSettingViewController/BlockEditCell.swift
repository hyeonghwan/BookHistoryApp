//
//  BlockEditCell.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/02.
//

import UIKit
import SnapKit

final class BlockLogCell: UITableViewCell{
    
    private lazy var nameLable: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(timeLabel)
        
        nameLable.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(12)
            $0.top.equalToSuperview().inset(5)
        }
        
        timeLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(12)
            $0.top.equalTo(nameLable.snp.bottom).offset(5)
        }
    }
    
    func settingLog(_ name: String,_ time: String){
        nameLable.text = name
        timeLabel.text = time
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatal error occur")
    }
}
