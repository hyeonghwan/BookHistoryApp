//
//  CommentView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/05.
//

import UIKit
import SnapKit

final class CommentView: UIView {

    
    var commentImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imageView.image = UIImage(systemName: "bubble.left")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
     var commentCount: UILabel = {
        let label = UILabel()
         label.text = "1"
         label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
         label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.purple.cgColor
        self.layer.borderWidth = 2
        self.addSubview(commentImageView)
        self.addSubview(commentCount)
        
        commentImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-10)
            $0.width.height.equalTo(15)
        }
        
        commentCount.snp.makeConstraints{
            $0.leading.equalTo(commentImageView.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
}
