//
//  BookPagingTableViewCell.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


typealias CellModel = (PageModel,PageSettingAction)

extension Reactive where Base: BookPagingTableViewCell{
    var cellBinder: Binder<CellModel>{
        return Binder(self.base){ cell, model in
            cell.bindModelToCell(model)
        }
    }
}

final class BookPagingTableViewCell: UITableViewCell{
    
    
    
    weak var pageModelAction: PageSettingAction?
    
    var disposeBag = DisposeBag()
    
    
    //MARK: - Bind to ViewModel
    func bindModelToCell(_ model: CellModel){
        self.titleLable.text = model.0.title
        
        self.pageModelAction = model.1
        
        self.pageModelAction?
            .showSettingPageButtonTapped(settingButton.rx.tap.asDriver(),
                                         model.0,
                                         self.disposeBag)
    }
  
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    //MARK: - UI Configure
    private lazy var container: UIView = {
        let view = UIView()
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.systemPink.cgColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "book")
        imageView.tintColor = .systemPink
        return imageView
    }()
    
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "test"
        label.textColor = UIColor.label
        return label
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .systemPink
        return button
    }()
  
    
    private func configure() {
        self.selectionStyle = .default
        
        self.contentView.addSubview(container)
        
        
        container.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
        }
        
        [iconImageView,
         titleLable,
         settingButton
        ].forEach{
            container.addSubview($0)
        }
        
        iconImageView.snp.makeConstraints{
            $0.width.height.equalTo(30)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        titleLable.snp.makeConstraints{
            $0.leading.equalTo(iconImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(settingButton.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        settingButton.snp.makeConstraints{
            $0.width.height.equalTo(25)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
        
    }
    
}
