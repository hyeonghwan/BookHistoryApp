//
//  TextPropertyMenuView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/15.
//

import UIKit
import SnapKit

class TextPropertyMenuView: UIView {
    

    
    //Second TextView UndoManager
    var textViewUndoManager: UndoManager?
    
    
    // state inputView is active
    var inputViewState: Bool = false {
        didSet{
            if self.inputViewState {
                self.keyDownButton.setImage(UIImage(systemName: "x.circle"), for: .normal)
            }
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
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
    
    
    private lazy var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    let buttonArr: [UIButton] = []
    
    private lazy var separatorLine2: UIView = {
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
    
    
    private lazy var backGroundPickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("가", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.addTarget(self, action: #selector(glyphColorMenuTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var backGroundPickerView: BackGroundPickerView = {
        let view = BackGroundPickerView()
        return view
    }()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addBorder(side: .top, thickness: CGFloat(1), color: UIColor.systemPink.cgColor)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    func settingFrame(_ frame: CGRect,_ heihgt: CGFloat){
        var beforeFrame = frame
        beforeFrame.size.height += heihgt
        beforeFrame.origin.y -= heihgt

        self.frame = beforeFrame
        
    }
    
    @objc private func glyphColorMenuTapped(_ sender: UIButton){
        
        NotificationCenter.default.post(Notification(name: Notification.dismissKeyBoard))
        
        
    }
    
    @objc private func keyDownTapped(_ sender: UIButton){
        
        if !inputViewState{
            NotificationCenter.default.post(Notification(name: Notification.keyDown))
        }else{
            NotificationCenter.default.post(Notification(name: Notification.dismissKeyBoard))
        }
        
    }
    
    
    @objc private func undoButtonTapped(_ sender: UIButton){
        textViewUndoManager?.undo()
        undoButton.isEnabled = textViewUndoManager?.canUndo ?? false
    }
    
    @objc private func redoButtonTapped(_ sender: UIButton){
        textViewUndoManager?.redo()
        redoButton.isEnabled = textViewUndoManager?.canRedo ?? false
    }
    
    
}
private extension TextPropertyMenuView {
    
    func changeColorViewConfiguration() {
        self.addSubview(backGroundPickerView)
        backGroundPickerView.snp.makeConstraints{
            $0.top.equalTo(self.scrollView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
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
        
        (1...8).forEach{ k in
            print(k)
            let button = UIButton()
            button.contentMode = .scaleAspectFit
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.backgroundColor = .systemPink
            stackView.addArrangedSubview(button)
            button.snp.makeConstraints{
                $0.width.height.equalTo(44)
            }
        }
        

        
        stackView.addArrangedSubview(backGroundPickerButton)
        
        backGroundPickerButton.snp.makeConstraints{
            $0.width.height.equalTo(30)
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
        
        let spacingView = UIView()
        
        stackView.addArrangedSubview(spacingView)
        
        spacingView.snp.makeConstraints{
            $0.width.height.equalTo(30)
        }
        
       
        
        
        
    }
    
}
