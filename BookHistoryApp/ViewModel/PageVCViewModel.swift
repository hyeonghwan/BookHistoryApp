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
    var pageModel: PageModel?
    // view Transaction Action
}

protocol PageVCDependencyInput{
    func makeTextPropertMenuViewDependencies() -> TextPropertyMenuView
    func makeTextViewDependencies(_ photoAndFileDelegate: PhotoAndFileDelegate) -> PageTextView
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
    func textViewShouldChangeTextIn(_ textView: UITextView,
                                    shouldChangeTextIn range: NSRange,
                                    replacementText text: String) -> Bool
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
    func setParagraphUseCase(_ validator: ParagraphValidatorProtocol)
}

typealias PageVCViewModelProtocol = PageVCViewModelOutPut & PageVCViewModelInput & PageTextViewInput & PageVCDependencyInput & PageDelegate

class PageVCViewModel: PageDelegate {
    
    struct PageDependencies{
        let inputViewModel: InputViewModelProtocol
        let colorViewModel: ColorViewModelProtocol
        let contentViewModel: ContentViewModelProtocol
        let accessoryViewModel: AccessoryCompositinalProtocol
        let blockViewModel: BlockViewModelProtocol
        let bookPagingViewModel: PagingType
    }
    
    private let actions: PageViewModelActions
    
    weak var pageVC: PageVC?
    var diposeBag: DisposeBag = DisposeBag()
    
    func setParagraphUseCase(_ validator: ParagraphValidatorProtocol) {
        self.paragraphValidator = validator
        self.paragraphValidator?.contentViewModel = self.contentViewModel
        self.paragraphValidator?.pageViewModel = self
    }
    
    
    var paragraphValidator: ParagraphValidatorProtocol?
    
    weak var bookPagingViewModel: PagingType?
    
    // KeyBoard InputViewType State ViewModel
    var inputViewModel: InputViewModelProtocol
    
    // TextView Color Type State ViewModel
    var colorViewModel: ColorViewModelProtocol
    
    // TextView Save Content State ViewModel
    var contentViewModel: ContentViewModelProtocol
    
    var accessoryViewModel: AccessoryCompositinalProtocol
    
    var blockViewModel: BlockViewModelProtocol
    
    
    init(_ dependencies: PageDependencies,
         _ actions: PageViewModelActions){
        
        self.actions = actions
        self.inputViewModel = dependencies.inputViewModel
        self.colorViewModel = dependencies.colorViewModel
        self.bookPagingViewModel = dependencies.bookPagingViewModel
        self.contentViewModel = dependencies.contentViewModel
        self.accessoryViewModel = dependencies.accessoryViewModel
        self.blockViewModel = dependencies.blockViewModel
    }
    
    deinit {
        print("pageVCViewModel deinit")
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
        contentViewModel.toMetaDataURL
    }
    
    var outputLongPressObservable: Observable<Bool>?{
        inputViewModel.outputLongPressObservable
    }
    
    var toTextObservable: Observable<BookViewModelData>?{
        contentViewModel.toTextObservable
    }
    
}
extension PageVCViewModel: PageTextViewInput{
    func storeBlockValue(_ button: Signal<Void>) {
        self.contentViewModel.storeBlockValues(button)
    }
    
    func textViewDidChangeSelection() {
     
    }
    
    func textViewDidChange() {
     
    }
    
    
    func textViewShouldChangeTextIn(_ textView: UITextView,
                                    shouldChangeTextIn range: NSRange,
                                    replacementText text: String) -> Bool{
        
        let paragraphRange = textView.getParagraphRange(range)
        
        if paragraphRange.length == 0 {
            textView.typingAttributes = pageVC!.defaultAttribute
            return true
        }
        let blockAttribute = CustomBlockType.Base.paragraph
        
        //toggle place holder detect
        guard let paragraphValidator = self.paragraphValidator else {return false}
        
        return paragraphValidator.isValidBlock(text, paragraphRange, blockAttribute)
    }
}

extension PageVCViewModel: PageVCViewModelInput{
    func viewDidLoad() {
        guard let viewModel = self.bookPagingViewModel else {return}
        guard let model = actions.pageModel else {
            self.contentViewModel.paragraphTrackingUtility.rx.blockObjects.onNext([])
            return
        }
        
        viewModel.getChildBlocksOFPage(model)
            .map{ $0.compactMap{ page_block in page_block.ownObject} }
            .bind(to: self.contentViewModel.paragraphTrackingUtility.rx.blockObjects)
            .disposed(by: self.diposeBag)

    }
    
    func viewWillDissapear() {
        
    }
    
    func pageSettupBinding() {
        
    }
    
    func keyboardWillShow() {
        inputViewModel.inputLongPressObserver.onNext(true) //false
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
        
        inputViewModel
            .outputStateObservable
            .bind(to: pageVC.textMenuView.rx.state)
            .disposed(by: pageVC.disposeBag)
            
        colorViewModel
                .updateUndoButtonObservable
                .withUnretained(self)
                .bind(onNext: {owend,_ in owend.pageVC?.updateUndoButtons() })
                .disposed(by: pageVC.keyBoardDisposeBag)
        // disposeBag  , keyBoardDisposeBag
    }
    
    func keyboardWillHide() {
        inputViewModel.inputLongPressObserver.onNext(true)
    }
    
    func keyDownTapped() {
    }
    
    
    func keyBoardChangeOriginal() {
        self.inputViewModel.inputStateObserver.onNext(.originalkeyBoard)
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
        self.inputViewModel.inputStateObserver.onNext(.backAndForeGroundColorState)
    }
    
    private func keyBoardChangeInputViewActionColorViewModelBind(_ data: PresentationType){
        colorViewModel.onColorData.onNext(data)
    }
}


extension PageVCViewModel: PageVCDependencyInput{
  
    
    //MARK: - make Page Property menu
    func makeTextPropertMenuViewDependencies() -> TextPropertyMenuView{
        let dependencies = DependencyOfTextPropertyMenu(viewModel: inputViewModel,
                                                        accessoryViewModel: accessoryViewModel)
        return TextPropertyMenuView(frame: CGRect(x: 0, y: 0,
                                                 width: UIScreen.main.bounds.size.width,
                                                 height: 44),
                                    dependency: dependencies)
    }
    
    
    func makeTextViewDependencies(_ photoAndFileDelegate: PhotoAndFileDelegate) -> PageTextView{
        let dependencies = PageTextView.DependencyOfTextView(colorViewModel: colorViewModel,
                                                             contentViewModel: contentViewModel,
                                                             accessoryViewModel: accessoryViewModel,
                                                             photoAndFileDelegate: photoAndFileDelegate,
                                                             blockViewModel: blockViewModel,
                                                             inputViewModel: inputViewModel)
        return pageTextViewSetting(depenencies: dependencies)
    }
    
    private func pageTextViewSetting(depenencies: PageTextView.DependencyOfTextView) -> PageTextView {
        let paragraphTextStorage = ParagraphTextStorage()
        
        paragraphTextStorage.paragraphDelegate = makeParagraphTrackingDependency()
        
        let layoutManager = TextWrapLayoutManager()
        
        layoutManager.textStorage = paragraphTextStorage
        
        let customTextContainer = CustomTextContainer(size: .zero)
        
        paragraphTextStorage.addLayoutManager(layoutManager)
        
        layoutManager.addTextContainer(customTextContainer)
        
        let textView = PageTextView(frame:.zero,
                                      textContainer: customTextContainer,
                                      depenencies)
        
        paragraphTrackingDependencySetting(textView)
        
        return textView
    }
    
    func paragraphTrackingDependencySetting(_ textView: UITextView) {
        contentViewModel.paragraphTrackingUtility.paragrphTextView = textView
    }
    
    private func makeParagraphTrackingDependency() -> ParagraphTextStorageDelegate {
        return contentViewModel.paragraphTrackingUtility.self
    }
    
}
