//
//  NasaPhotoDetailViewController.swift
//  NasaAPOD-Facade
//
//  Created by Ashley Ng on 11/1/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit

class NasaPhotoDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private let apiFacade: ApiFacade
    private let photoInfo: NasaPhotoInfo
    
    init(photoInfo: NasaPhotoInfo, apiFacade: ApiFacade = ApiFacade()) {
        self.apiFacade = apiFacade
        self.photoInfo = photoInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        self.photoTitle.text = photoInfo.title
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        formatter.string(from: photoInfo.date)
        self.date.text = formatter.string(from: photoInfo.date)
        self.textView.text = photoInfo.description
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        
        apiFacade.fetchImage(for: photoInfo.photoUrl) { [weak self] image in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.imageView.image = image
            }
        }
    }

}
