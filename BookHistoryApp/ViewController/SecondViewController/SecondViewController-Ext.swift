//
//  SecondViewController-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/08.
//

import UIKit

protocol PhotoAndFileDelegate: AnyObject {
    func presentPhotoLibrary()
    func presentCamera()
    func presentFile()
}

extension SecondViewController: PhotoAndFileDelegate{
    
    private var imagePickerVC: UIImagePickerController {
       UIImagePickerController()
    }
    
    func presentPhotoLibrary() {
        let vc = imagePickerVC
        vc.sourceType = .photoLibrary
        vc.delegate = self // new
        present(vc, animated: true)
    }
    
    func presentCamera() {
        let vc = imagePickerVC
        vc.sourceType = .camera
        vc.delegate = self // new
        present(vc, animated: true)
    }
    
    func presentFile() {

    }
    
    
}

extension SecondViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.imageURL] as? URL else {print("nil"); return}
        print(image)
        guard let mediaType = info[.mediaType] as? NSString else {return}
        print("mediaTypeL \(mediaType)")
    }
}
