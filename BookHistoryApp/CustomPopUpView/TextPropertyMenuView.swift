//
//  TextPropertyMenuView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct MenuButtonType{
    let type: MenuActionType?
    let image: String?
    let disposeBag: DisposeBag?
    let viewModel: AccessoryCompositionProtocol?
    let frame: CGRect?
    let color: UIColor?
    
    init(type: MenuActionType,
         image: String,
         disposeBag: DisposeBag,
         viewModel: AccessoryCompositionProtocol,
         _ frame: CGRect = CGRect(x: 0, y: 0, width: 30, height: 30),
         _ color: UIColor = UIColor.lightGray) {
        
        self.type = type
        self.image = image
        self.disposeBag = disposeBag
        self.viewModel = viewModel
        self.frame = frame
        self.color = color
    }
}


class TextPropertyMenuView: UIView {
        
    //Second TextView UndoManager
    var textViewUndoManager: UndoManager?
    
    var viewModel: InputViewModelType?
    
    var accessoryViewModel: AccessoryCompositionProtocol?
    
    
    var menuButtonDisposeBag = DisposeBag()
    
    //input
    var state: KeyBoardState? {
        didSet{
            switch self.state{
            case .originalkeyBoard:
                self.keyDownButton.setImage(UIImage(systemName: "keyboard.chevron.compact.down"), for: .normal)

            case .backAndForeGroundColorState:
                self.keyDownButton.setImage(UIImage(systemName: "x.circle"), for: .normal)

            case .none:
                print("nil")
            }
        }
    }
    
  
    
    var keyBoardObserver: AnyObserver<KeyBoardState>?
    
    private var disposeBag = DisposeBag()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addBorder(side: .top, thickness: CGFloat(1), color: UIColor.systemPink.cgColor)
    }

    
    convenience init(frame: CGRect,
                     viewModel: InputViewModelType,
                     accessoryViewModel: AccessoryCompositionProtocol){
        
        self.init(frame: frame)
        
        self.viewModel = viewModel
        self.accessoryViewModel = accessoryViewModel
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 25
        stackView.axis = .horizontal
        return stackView
    }()
    
    
    private lazy var keyDownButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "keyboard.chevron.compact.down"), for: .normal)
        button.addTarget(self, action: #selector(keyDownTapped(_:)), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        button.tintColor = .systemGray
        return button
    }()
    
    
    
    private lazy var blockAddButton: UIButton = {
        let button = UIButton()
        let type = MenuButtonType(type: .blockAdd,
                                  image: "plus",
                                  disposeBag: menuButtonDisposeBag,
                                  viewModel: accessoryViewModel!)
        button.inputAccessoryButton_Frame_Color_Image_Action_Setting(type)
        return button
    }()
    
    private lazy var blockParagraphSettingButton: UIButton = {
        let button = UIButton()
        let type = MenuButtonType(type: .paragraphSetting,
                                  image:"arrow.rectanglepath",
                                  disposeBag: menuButtonDisposeBag,
                                  viewModel: accessoryViewModel!)
        button.inputAccessoryButton_Frame_Color_Image_Action_Setting(type)
        return button
    }()
    
    private lazy var blockCommentButton: UIButton = {
        let button = UIButton()
        let type = MenuButtonType(type: .blockComment,
                                  image:"bubble.left",
                                  disposeBag: menuButtonDisposeBag,
                                  viewModel: accessoryViewModel!)
        button.inputAccessoryButton_Frame_Color_Image_Action_Setting(type)
        return button
    }()
    
    private lazy var blockImageButton: UIButton = {
        let button = UIButton()
        let type = MenuButtonType(type: .blcokimage,
                                  image:"photo.on.rectangle.angled",
                                  disposeBag: menuButtonDisposeBag,
                                  viewModel: accessoryViewModel!)
        button.inputAccessoryButton_Frame_Color_Image_Action_Setting(type)
        return button
    }()
    
    private lazy var boldItalicUnderLineButton: UIButton = {
        let button = UIButton()
        let type = MenuButtonType(type: .boldItalicUnderLine,
                                  image:"bold.italic.underline",
                                  disposeBag: menuButtonDisposeBag,
                                  viewModel: accessoryViewModel!)
        button.inputAccessoryButton_Frame_Color_Image_Action_Setting(type)
        return button
    }()
    
    private lazy var blockRemoveButton: UIButton = {
        let button = UIButton()
        let type = MenuButtonType(type: .blockRemove,
                                  image:"trash",
                                  disposeBag: menuButtonDisposeBag,
                                  viewModel: accessoryViewModel!)
        button.inputAccessoryButton_Frame_Color_Image_Action_Setting(type)
        return button
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    
    private lazy var separatorLine2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    private lazy var separatorLine3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    private lazy var separatorLine4: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    
    lazy var undoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.uturn.backward"), for: .normal)
        button.addTarget(self, action: #selector(undoButtonTapped(_:)), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        button.tintColor = .systemGray
        return button
    }()
    
    lazy var redoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.uturn.right"), for: .normal)
        button.addTarget(self, action: #selector(redoButtonTapped(_:)), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        button.tintColor = .systemGray
        return button
    }()
    
    
    private lazy var blockBackGroundPickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("가", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.addTarget(self, action: #selector(glyphColorMenuTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var blockSettingButton: UIButton = {
        let button = UIButton()
        let type = MenuButtonType(type: .blcokSetting,
                                  image:"ellipsis",
                                  disposeBag: menuButtonDisposeBag,
                                  viewModel: accessoryViewModel!)
        button.inputAccessoryButton_Frame_Color_Image_Action_Setting(type)
        return button
    }()
    
    private lazy var blockTapButton: UIButton = {
        let button = UIButton()
        let type = MenuButtonType(type: .blockTap,
                                  image:"decrease.indent",
                                  disposeBag: menuButtonDisposeBag,
                                  viewModel: accessoryViewModel!)
        button.inputAccessoryButton_Frame_Color_Image_Action_Setting(type)
        return button
    }()
    
    private lazy var blockTapCancelButton: UIButton = {
        let button = UIButton()
        let type = MenuButtonType(type: .blcokTapCancel,
                                  image:"increase.indent",
                                  disposeBag: menuButtonDisposeBag,
                                  viewModel: accessoryViewModel!)
        button.inputAccessoryButton_Frame_Color_Image_Action_Setting(type)
        return button
    }()
    
    private lazy var blockUpButton: UIButton = {
        let button = UIButton()
        let type = MenuButtonType(type: .blockUp,
                                  image:"arrow.up.to.line",
                                  disposeBag: menuButtonDisposeBag,
                                  viewModel: accessoryViewModel!)
        button.inputAccessoryButton_Frame_Color_Image_Action_Setting(type)
        return button
    }()
    
    private lazy var blcokDownButton: UIButton = {
        let button = UIButton()
        let type = MenuButtonType(type: .blcokDown,
                                  image:"arrow.down.to.line",
                                  disposeBag: menuButtonDisposeBag,
                                  viewModel: accessoryViewModel!)
        button.inputAccessoryButton_Frame_Color_Image_Action_Setting(type)
        return button
    }()
    
    func settingFrame(_ frame: CGRect,_ heihgt: CGFloat){
        var beforeFrame = frame
        beforeFrame.size.height += heihgt
        beforeFrame.origin.y -= (heihgt )
        self.frame = beforeFrame
    }
    
    @objc private func glyphColorMenuTapped(_ sender: UIButton){
        NotificationCenter.default.post(Notification(name: Notification.changeInputView))
    }
    
    @objc private func keyDownTapped(_ sender: UIButton){
        
        switch self.state{
        case .originalkeyBoard:
            NotificationCenter.default.post(Notification(name: Notification.keyDown))
        
        case .backAndForeGroundColorState:
            NotificationCenter.default.post(Notification(name: Notification.changeOriginalKeyBoard))
        
        case .none:
            break
        }
    }
    
    
    @objc private func undoButtonTapped(_ sender: UIButton){
        textViewUndoManager?.undo()
        undoButton.isEnabled = textViewUndoManager?.canUndo ?? false
        redoButton.isEnabled = textViewUndoManager?.canRedo ?? false
    }
    
    @objc private func redoButtonTapped(_ sender: UIButton){
        textViewUndoManager?.redo()
        undoButton.isEnabled = textViewUndoManager?.canUndo ?? false
        redoButton.isEnabled = textViewUndoManager?.canRedo ?? false
    }
    
    
}
private extension TextPropertyMenuView {
   
    
    func configure(){
        
        [scrollView,separatorLine,keyDownButton].forEach{
            self.addSubview($0)
        }
        
        scrollView.addSubview(stackView)
        
        
        scrollView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(44)
            $0.height.equalTo(44)
        }
        
        keyDownButton.snp.makeConstraints{
            $0.width.height.equalTo(44)
            $0.trailing.equalToSuperview()
        }
        
        separatorLine.snp.makeConstraints{
            $0.height.equalTo(22)
            $0.width.equalTo(1)
            $0.centerY.equalTo(keyDownButton.snp.centerY)
            $0.trailing.equalTo(keyDownButton.snp.leading)
        }
        
     
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }

        [blockAddButton,
         blockParagraphSettingButton,
         blockImageButton,
         blockCommentButton,
         boldItalicUnderLineButton,
         blockRemoveButton]
            .forEach{
            stackView.addArrangedSubview($0)
        }
        
        separatorLine2.snp.makeConstraints{
            $0.height.equalTo(22)
            $0.width.equalTo(1)
        }
        
        stackView.addArrangedSubview(separatorLine2)
        
        [undoButton,redoButton].forEach{
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints{
                $0.width.equalTo(30)
                $0.height.equalTo(44)
            }
        }
        
        [blockBackGroundPickerButton,
         blockSettingButton,
         separatorLine4,
         blockTapButton,
         blockTapCancelButton,
         blockUpButton,
         blcokDownButton].forEach{
            stackView.addArrangedSubview($0)
        }
        
        blockBackGroundPickerButton.snp.makeConstraints{
            $0.width.equalTo(25)
            $0.height.equalTo(25)
        }
        
        separatorLine4.snp.makeConstraints{
            $0.height.equalTo(22)
            $0.width.equalTo(1)
        }
    }
}
