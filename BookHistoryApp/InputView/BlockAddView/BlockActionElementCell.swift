//
//  BlockActionElementCell.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/11.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift


final class BlockActionElementCell: UICollectionViewCell{
    
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private (set) var pipe = PublishSubject<CollectionViewElement>()
    private (set) var content: Observable<CollectionViewElement>
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        
        content = pipe.asObservable()
        
        super.init(frame: frame)
        
        content
            .asDriver(onErrorJustReturn: CollectionViewElement(name: "", image: ""))
            .drive(onNext: { data in
                self.label.text = data.name
                self.imageView.image = UIImage(systemName: data.image)
            })
            .disposed(by: disposeBag)
        
        addAutoLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    var cornerRadius: CGFloat = 5.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
    }
    
    

    private func addAutoLayout(){
        
        
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        
        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        // Apply a shadow
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        
        self.contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(label)
        
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(6)
            $0.width.equalTo(30)
        }
        
        label.snp.makeConstraints{
            $0.leading.equalTo(imageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
    }
    
    
}
