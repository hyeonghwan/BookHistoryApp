/**
 Available under the MIT License
 Copyright (c) 2017 Vlas Voloshin
*/

import UIKit
//import SubviewAttachingTextView
//
//import WebKit
//import PlaygroundSupport
//
//// Handles tapping on the image view attachment
//class TapHandler: NSObject {
//    @objc func handle(_ sender: UIGestureRecognizer!) {
//        if let imageView = sender.view as? UIImageView {
//            imageView.alpha = CGFloat(arc4random_uniform(1000)) / 1000.0
//        }
//    }
//}
//
//
//// Load lorem ipsum from a file and create a long attributed string out of it
//
//let loremIpsum = try! String(contentsOf: #fileLiteral(resourceName: "lorem-ipsum.txt"))
//let repeatedLorem = String(repeating: loremIpsum, count: 3)
//let text = NSAttributedString(string: repeatedLorem, attributes: [ .font : UIFont.systemFont(ofSize: 14) ])
//
//// Make paragraph styles for attachments
//let centerParagraphStyle = NSMutableParagraphStyle()
//centerParagraphStyle.alignment = .center
//centerParagraphStyle.paragraphSpacing = 10
//centerParagraphStyle.paragraphSpacingBefore = 10
//
//let leftParagraphStyle = NSMutableParagraphStyle()
//leftParagraphStyle.alignment = .left
//leftParagraphStyle.paragraphSpacing = 10
//leftParagraphStyle.paragraphSpacingBefore = 10
//
//// Create an image view with a tap recognizer
//let imageView = UIImageView(image: #imageLiteral(resourceName: "mona.jpg"))
//imageView.contentMode = .scaleAspectFit
//imageView.isUserInteractionEnabled = true
//let handler = TapHandler()
//let gestureRecognizer = UITapGestureRecognizer(target: handler, action: #selector(TapHandler.handle(_:)))
//imageView.addGestureRecognizer(gestureRecognizer)
//
//// Create an activity indicator view
//let spinner = UIActivityIndicatorView(style: .large)
//spinner.color = .black
//spinner.hidesWhenStopped = false
//spinner.startAnimating()
//
//// Create a text field
//let textField = UITextField()
//textField.borderStyle = .roundedRect
//
//// Create a web view, because why not
//let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
//webView.load(URLRequest(url: URL(string: "https://revealapp.com")!))
//
//// Create a text view to display the string and attachments
//let textView = SubviewAttachingTextView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
//
//// Add attachments to the string and set it on the text view
//// This example avoids evaluating the attachments or attributed strings with attachments in the Playground because Xcode crashes trying to decode attachment objects
//textView.attributedText = text
//    .insertingAttachment(SubviewTextAttachment(view: imageView, size: CGSize(width: 256, height: 256)), at: 100, with: centerParagraphStyle)
//    .insertingAttachment(SubviewTextAttachment(view: spinner), at: 200)
//    .insertingAttachment(SubviewTextAttachment(view: UISwitch()), at: 300)
//    .insertingAttachment(SubviewTextAttachment(view: textField, size: CGSize(width: 200, height: 44)), at: 400, with: leftParagraphStyle)
//    .insertingAttachment(SubviewTextAttachment(view: UIDatePicker()), at: 500, with: centerParagraphStyle)
//    .insertingAttachment(SubviewTextAttachment(view: webView), at: 600, with: centerParagraphStyle)
//
//
//// Run the playground indefinitely with the text view as the live view
//PlaygroundPage.current.needsIndefiniteExecution = true
//PlaygroundPage.current.liveView = textView
//var paragrphs: [String] = ["234"]
//var ranges: [NSRange] = [NSRange(location: 15, length: 10)]
//for paragraph in paragraphs.dropFirst() {
//    ranges.append( NSRange(location: ranges.last!.max, length: paragraph.length) )
//}

//class Jake3 {
//    let name = "Jake3"
//    var closure: (() -> ())?
//
//
//    init() {
//        let outerClosure = {
//            let internalClosure = { [weak self] in // 안쪽 closure에서 weak으로 self를 잡을때 이미 outerClosure에서 strong
//                print("1234")
//                print(self?.name)
//            }
//            print("456")
//            internalClosure()
//        }
//        closure = outerClosure
//        print("789")
//        closure?()
//        closure = nil
//    }
//
//    deinit {
//        print("DEINIT3")
//    }
//}
//
//var jake3: Jake3? = Jake3()
//jake3 = nil
//
//class Jake4 {
//    let name = "Jake"
//
//    lazy var closure: (() -> ())? = {
//        print(self.name) // 참조: closure -> self
//    }
//
//    init() {
//        closure?() // 참조: self -> closure
//        print("jake 4")
//
//    }
//
//    deinit {
//        print("DEINIT: Jake4")
//    }
//}
//
//var jake4: Jake4? = Jake4()
//jake4?.closure = nil
//jake4 = nil

import Foundation

func solution(_ k:Int, _ m:Int, _ score:[Int]) -> Int {

    let bestPrice = k
    var boxCount = m
    var list = score.sorted(by: { $0 > $1})
    print(list)
    var sum: Int = 0
    var result: [Int] = []
    while list.count == 0{
        let e = list.remove(at: 0)
        result.append(e)
        
    }
    
    
    return 0
}


solution(3, 4, [1,2,3,4,1,2,3,4])
