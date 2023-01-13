//
//  BlockAddView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct CollectionViewElement{
    let name: String
    let image: String
}

final class BlockAddView: UIInputView{
    
 
    private weak var blockVM: BlockVMProtocol?
    
    var disposeBag = DisposeBag()
    
    private var screenWidhth: CGFloat = UIApplication.shared.screenWidth ?? 0
    
    private var buttonInset: CGFloat = 12
    
    private lazy var buttonWidth: CGFloat = screenWidhth / 2 - (buttonInset + 6)
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: buttonWidth, height: 60)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BlockActionElementCell.self, forCellWithReuseIdentifier: BlockActionElementCell.identify)
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 12, bottom: 0, right: 12)
        self.backgroundColor = .systemBackground
        
        return collectionView
    }()
    
    override init(frame: CGRect,inputViewStyle: UIInputView.Style) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    convenience init(frame: CGRect, inputViewStyle: UIInputView.Style, dependency: BlockVMProtocol) {
        self.init(frame: frame, inputViewStyle: inputViewStyle)
        
        self.blockVM = dependency
        addAutoLayout()
        settUpBinding()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    func settUpBinding(){
        blockVM?
            .blockActionModel
            .bind(to: collectionView.rx.items(cellIdentifier: BlockActionElementCell.identify,
                                              cellType: BlockActionElementCell.self)){
                index, item, cell in
                print(item)
                cell.pipe.onNext(item)
                
            }.disposed(by: disposeBag)
        
        let blockInput = BlockInput(blockActionInput: collectionView.rx.modelSelected(CollectionViewElement.self).asObservable())
        blockVM?.createBlockActionInPut(blockInput)
    }
}

private extension BlockAddView{
    func addAutoLayout(){
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
}



