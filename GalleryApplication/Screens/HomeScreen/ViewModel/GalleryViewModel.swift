//
//  GalleryViewModel.swift
//  GalleryApplication
//
//  Created by Utsav Shah on 31/03/24.
//

import Foundation

protocol GalleryViewModelDelegate : AnyObject {
    func handleGalleryResponse(responce: galleryData)
}

class GalleryViewModel: NSObject {

    private weak var delegate : GalleryViewModelDelegate?
    
    init(delegate : GalleryViewModelDelegate? = nil) {
        self.delegate = delegate
    }
}

extension GalleryViewModel {
    
    func performApiCallingForGallery(page: String?) {
        Utils.showSpinner()
        let paaram = ["key":"43162282-9a68f1ae80a41b8d16b9dfa76", "category":"animals", "page": page]
        NetworkManager.shared.requestGet(path: "" , params: paaram) { (result, error, _) in
            Utils.hideSpinner()
            if error == nil {
                NetworkManager.shared.handleResponse(result: result) { (value) in
                    let data: galleryData? = NetworkManager.shared.decodeObject(fromData: value)
                    if let data = data {
                        self.delegate?.handleGalleryResponse(responce: data)
                    }
                }
            } else {
                Utils.hideSpinner()
                Utils.alert(message: error?.localizedDescription ?? "")
            }
        }
    }
}
