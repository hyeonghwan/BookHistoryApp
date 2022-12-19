//
//  MyDynamicView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/19.
//

import UIKit

class MyDynamicView: UIView {

    var text: String? {
        didSet{ bind() }
    }
    
    var image: String? {
        didSet{ self.imageView.image = UIImage(systemName: self.image ?? "circle") ?? UIImage(systemName: "circle")}
    }
    
    var completion: ((CGSize) -> ())?

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "circle")
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addsubviews()
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemeneted")
    }

    private func addsubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
    }

    private func setupView() {
        backgroundColor = .lightGray
        layer.cornerRadius = 14.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 3.0
    }

    private func bind() {
        titleLabel.text = text
        setupDynamicLayout()
    }


    private func setupDynamicLayout() {
        titleLabel.sizeToFit()
        let viewSize = titleLabel.intrinsicContentSize
        let imageFrame = imageView.frame
        
        var width: CGFloat = 0
        let height = imageFrame.size.height + 20
        
        if viewSize.width > 0 {
           width = imageFrame.size.width + 10 + 10 + viewSize.width + 10
            
            titleLabel.frame.origin.x = imageFrame.size.width + 10 + 10
            titleLabel.center.y = height / 2
        }else {
            width = imageFrame.size.width + 10 + 10
        }
        
        frame.size = CGSize(width: width, height: height)
        completion?(frame.size)
    }
}
