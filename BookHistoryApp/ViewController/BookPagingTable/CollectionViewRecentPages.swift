//
//  CollectionViewRecentPages.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/20.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class PageCell: UICollectionViewCell {
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "book")
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .systemPink
        return imageView
    }()
    
    
    var onRecentPageData: AnyObserver<PageModel>
    
    var cellDisposeBag = DisposeBag()
    var disposeBag = DisposeBag()
    
    
    override init(frame: CGRect) {
        let pagePipe = PublishSubject<PageModel>()
        
        onRecentPageData = pagePipe.asObserver()
        
        super.init(frame: frame)
        
        addAutoLayout()
        
        pagePipe
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] page in
                guard let self = self else {return}
                self.titleLabel.text = page.title
            }).disposed(by: cellDisposeBag)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    

    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
    
    @objc func dopinch(_ pinch: UIPinchGestureRecognizer){
        contentImageView.transform = contentImageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1
    }
    
    func addAutoLayout() {
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(dopinch(_:)))
        self.contentView.addGestureRecognizer(pinch)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.label.cgColor
        contentView.layer.cornerRadius = 10
        
        
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(separatorLine)
        self.contentView.addSubview(contentImageView)
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.centerX.equalToSuperview()
        }
        separatorLine.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(1)
        }
        
        contentImageView.snp.makeConstraints{
            $0.top.equalTo(separatorLine.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
    }
    
}
