//
//  ViewModelAction.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/11.
//

import UIKit
import ParagraphTextKit
import RxSwift
import RxCocoa

struct PageViewModelActions{
    // view Transaction Action
}

protocol PageVCDependencyInput{
    func makeTextPropertMenuViewDependencies() -> TextPropertyMenuView
    func makeTextViewDependencies(_ photoAndFileDelegate: PhotoAndFileDelegate) -> UITextView
}

protocol PageVCViewModelInput{
    func viewDidLoad()
    
    func viewWillDissapear()
    func pageSettupBinding()
    
    func keyboardWillShow()
    func keyboardDidShow(_ notification: Notification?)
    func keyboardWillHide()
    func keyDownTapped()
    
    func keyBoardChangeInputViewAction()
    func keyBoardChangeOriginal()
}

protocol PageTextViewInput{
    func storeBlockValue(_ button: Signal<Void>)
    func textViewDidChangeSelection()
    func textViewDidChange()
    func textViewShouldChangeTextIn(_ textView: UITextView)
}


protocol PageVCViewModelOutPut{
    var toMetaDataURL: Observable<MetaDataDictionatyOnURL>? { get }
    var outputLongPressObservable: Observable<Bool>? { get }
    var toTextObservable: Observable<BookViewModelData>? { get }
}

protocol PageVCValidDelegate: AnyObject{
    func getRestRangeAndText(_ paragraphRange: NSRange) -> String?
    func resetParagraphToPlaceHodlerAttribute(_ data: ParagraphValidator.TextToValidData) -> Bool
}

protocol PageDelegate{
    var pageVC: PageVC? { get set }
}

typealias PageVCViewModelProtocol = PageVCViewModelOutPut & PageVCViewModelInput & PageTextViewInput & PageVCDependencyInput & PageDelegate

class PageVCViewModel: PageDelegate {
    private let actions: PageViewModelActions
    
    weak var pageVC: PageVC?
    
    
    var paragraphValidator: ParagraphValidatorProtocol?
    
    var bookPagingViewModel: PagingType?
    
    // KeyBoard InputViewType State ViewModel
    var inputViewModel: InputViewModelProtocol?
    
    // TextView Color Type State ViewModel
    var colorViewModel: ColorViewModelProtocol?
    
    // TextView Save Content State ViewModel
    var contentViewModel: ContentViewModelProtocol?
    
    var accessoryViewModel: AccessoryCompositinalProtocol?
    
    var blockViewModel: BlockViewModelProtocol?
    
    
    init(_ dependencies: PageDependencies,
         _ actions: PageViewModelActions){
        
        self.actions = actions
        self.paragraphValidator = dependencies.validator
        self.inputViewModel = dependencies.inputViewModel
        self.colorViewModel = dependencies.colorViewModel
        self.bookPagingViewModel = dependencies.bookPagingViewModel
        self.contentViewModel = dependencies.contentViewModel
        self.accessoryViewModel = dependencies.accessoryViewModel
        self.blockViewModel = dependencies.blockViewModel
    }
    
    
    //MARK: - Dependencies make
    //MARK: - View move func
}

extension PageVCViewModel: PageVCValidDelegate{
    
    func getRestRangeAndText(_ paragraphRange: NSRange) -> String?{
        guard let restRange = pageVC?.textView.textRangeFromNSRange(range: paragraphRange) else {return nil}
        guard let restText = pageVC?.textView.text(in: restRange) else {return nil}
        return restText
    }
    
    func resetParagraphToPlaceHodlerAttribute(_ data: ParagraphValidator.TextToValidData) -> Bool{
        guard let textView = pageVC?.textView else {return false}
        
        let restText = data.restText
        let paragraphRange = data.paragraphRange
        let text = data.text
        let replacement = data.replaceMent
        let type = data.type
        
        var attributes: [NSAttributedString.Key : Any] = [:]
        
        if type == .textHeadSymbolList{
            attributes = NSAttributedString.Key.textHeadSymbolListPlaceHolderAttributes
        }else{
            attributes = NSAttributedString.Key.togglePlaceHolderAttributes
        }
        
        if (restText.length == 3 && text == ""){
            textView.textStorage.beginEditing()
            textView.textStorage.replaceCharacters(in: NSRange(location: paragraphRange.location + 1,
                                                               length: paragraphRange.length - 2),
                                                   with: NSAttributedString(string: replacement,
                                                                            attributes: attributes))
            textView.textStorage.endEditing()
            
            textView.selectedRange = NSRange(location: paragraphRange.location + 1, length: 0)
            return false
        }
        return true
    }
}


extension PageVCViewModel: PageVCViewModelOutPut{
    
    var toMetaDataURL: Observable<MetaDataDictionatyOnURL>? {
        contentViewModel?.toMetaDataURL
    }
    
    var outputLongPressObservable: Observable<Bool>?{
        inputViewModel?.outputLongPressObservable
    }
    
    var toTextObservable: Observable<BookViewModelData>?{
        contentViewModel?.toTextObservable
    }
    
}
extension PageVCViewModel: PageTextViewInput{
    func storeBlockValue(_ button: Signal<Void>) {
        self.contentViewModel?.storeBlockValues(button)
    }
    
    func textViewDidChangeSelection() {
        <#code#>
    }
    
    func textViewDidChange() {
        <#code#>
    }
    
    func textViewShouldChangeTextIn(_ textView: UITextView) {
        
    }
}

extension PageVCViewModel: PageVCViewModelInput{
    func viewDidLoad() {
        
    }
    
    func viewWillDissapear() {
        
    }
    
    func pageSettupBinding() {
        
    }
    
    func keyboardWillShow() {
        inputViewModel?.inputLongPressObserver.onNext(true) //false
    }
    
    //_ state: some KeyBoardStateType
    func keyboardDidShow(_ notification: Notification?){
        guard let pageVC = pageVC else {return}
        
        var _kbSize:CGSize!
        
        if let info = notification?.userInfo{
            
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            
            //  Getting UIKeyboardSize.
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                
                let screenSize = UIScreen.main.bounds
                
                //Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381)
                let intersectRect = kbFrame.intersection(screenSize)
                
                if intersectRect.isNull {
                    _kbSize = CGSize(width: screenSize.size.width, height: 0)
                } else {
                    _kbSize = intersectRect.size
                }
                print("Your Keyboard Size \(String(describing: _kbSize))")
                
                
                keyBoardDidshowAction()
                
                pageVC.setKeyboardHeight(_kbSize.height)
                
                pageVC.keyBoardAppearLayout(_kbSize)
            }
        }
    }
    
    private func keyBoardDidshowAction(){
        guard let pageVC = pageVC else {return}
        inputViewModel?
            .outputStateObservable
            .bind(to: pageVC.textMenuView.rx.state)
            .disposed(by: pageVC.disposeBag)
            
        colorViewModel?
                .updateUndoButtonObservable
                .withUnretained(self)
                .bind(onNext: {owend,_ in owend.pageVC?.updateUndoButtons() })
                .disposed(by: pageVC.keyBoardDisposeBag)
        // disposeBag  , keyBoardDisposeBag
    }
    
    func keyboardWillHide() {
        inputViewModel?.inputLongPressObserver.onNext(true)
    }
    
    func keyDownTapped() {
    }
    
    
    func keyBoardChangeOriginal() {
        self.inputViewModel?.inputStateObserver.onNext(.originalkeyBoard)
    }
    
    func keyBoardChangeInputViewAction(){
        guard let pageVC = pageVC else {return}
        if let state = pageVC.textMenuView.state,
           state != .backAndForeGroundColorState{
            
            sendToinputViewStateAction()
            
            let backGroundPickerView = BackORForeColorPickerView()
            
            backGroundPickerView
                .buttonObservable
                .withUnretained(self)
                .bind(onNext: {owned , data in owned.keyBoardChangeInputViewActionColorViewModelBind(data)})
                .disposed(by: pageVC.keyBoardDisposeBag)
            
            pageVC.textView.inputView = backGroundPickerView
            
            pageVC.textView.reloadInputViews()
        }
    }
    
    private func sendToinputViewStateAction() {
        self.inputViewModel?.inputStateObserver.onNext(.backAndForeGroundColorState)
    }
    
    private func keyBoardChangeInputViewActionColorViewModelBind(_ data: PresentationType){
        colorViewModel?.onColorData.onNext(data)
    }
    
    
}





extension PageVCViewModel: PageVCDependencyInput{
    
    struct PageDependencies{
        let validator: ParagraphValidatorProtocol
        let inputViewModel: InputViewModelProtocol
        let colorViewModel: ColorViewModelProtocol
        let contentViewModel: ContentViewModelProtocol
        let accessoryViewModel: AccessoryCompositinalProtocol
        let blockViewModel: BlockViewModelProtocol
        let bookPagingViewModel: PagingType
    }
    
    //MARK: - make Page Property menu
    func makeTextPropertMenuViewDependencies() -> TextPropertyMenuView{
        let dependencies = DependencyOfTextPropertyMenu(viewModel: inputViewModel!,
                                                        accessoryViewModel: accessoryViewModel!)
        return TextPropertyMenuView(frame: CGRect(x: 0, y: 0,
                                                 width: UIScreen.main.bounds.size.width,
                                                 height: 44),
                                    dependency: dependencies)
    }
    
    //MARK: - make Page TextView Setting
    struct DependencyOfTextView{
        weak var colorViewModel: ColorViewModelProtocol?
        weak var contentViewModel: ContentViewModelProtocol?
        weak var accessoryViewModel: AccessoryCompositinalProtocol?
        weak var photoAndFileDelegate: PhotoAndFileDelegate?
        weak var blockViewModel: BlockViewModelProtocol?
        weak var inputViewModel: InputViewModelProtocol?
        
        init(colorViewModel: ColorViewModelProtocol?,
             contentViewModel: ContentViewModelProtocol?,
             accessoryViewModel: AccessoryCompositinalProtocol?,
             photoAndFileDelegate: PhotoAndFileDelegate?,
             blockViewModel: BlockViewModelProtocol?,
             inputViewModel: InputViewModelProtocol?) {
            
            self.colorViewModel = colorViewModel
            self.contentViewModel = contentViewModel
            self.accessoryViewModel = accessoryViewModel
            self.photoAndFileDelegate = photoAndFileDelegate
            self.blockViewModel = blockViewModel
            self.inputViewModel = inputViewModel
        }
    }

    
    func makeTextViewDependencies(_ photoAndFileDelegate: PhotoAndFileDelegate) -> UITextView{
        let dependencies = DependencyOfTextView(colorViewModel: colorViewModel!,
                                                contentViewModel: contentViewModel!,
                                                accessoryViewModel: accessoryViewModel!,
                                                photoAndFileDelegate: photoAndFileDelegate,
                                                blockViewModel: blockViewModel!,
                                                inputViewModel: inputViewModel!)
        return pageTextViewSetting(depenencies: dependencies)
    }
    
    private func pageTextViewSetting(depenencies: DependencyOfTextView) -> UITextView {
        let paragraphTextStorage = ParagraphTextStorage()
        
        paragraphTextStorage.paragraphDelegate = makeParagraphTrackingDependency()
        
        let layoutManager = TextWrapLayoutManager()
        
        layoutManager.textStorage = paragraphTextStorage
        
        let customTextContainer = CustomTextContainer(size: .zero)
        
        paragraphTextStorage.addLayoutManager(layoutManager)
        
        layoutManager.addTextContainer(customTextContainer)
        
        let textView = SecondTextView(frame:.zero,
                                      textContainer: customTextContainer,
                                      depenencies)
        
        paragraphTrackingDependencySetting(textView)
        
        return textView
    }
    
    private func paragraphTrackingDependencySetting(_ textView: UITextView) {
        contentViewModel?.paragraphTrackingUtility.paragrphTextView = textView
    }
    
    private func makeParagraphTrackingDependency() -> ParagraphTextStorageDelegate? {
        guard let contentViewModel = contentViewModel else {return nil}
        return contentViewModel.paragraphTrackingUtility.self
    }
    
}
