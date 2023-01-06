//
//  BlockTaskCell.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/02.
//

import UIKit
import SnapKit

final class BlockTaskCell: UITableViewCell{
    
    private lazy var labelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .label
        label.text = "default"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addAutoLayout()
    }
    
    func settingComponent( _ image: String, _ text: String) {
        self.label.text = text
        self.labelImageView.image = UIImage(systemName: image) ?? UIImage(systemName: "book")
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatal Error occur")
    }
    
    
    private func addAutoLayout(){
        self.contentView.addSubview(labelImageView)
        self.contentView.addSubview(label)
        
        labelImageView.snp.makeConstraints{
            $0.width.height.equalTo(25)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        label.snp.makeConstraints{
            $0.leading.equalTo(labelImageView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
}
