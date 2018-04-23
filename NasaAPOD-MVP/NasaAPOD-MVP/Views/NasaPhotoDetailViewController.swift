//
//  NasaPhotoDetailViewController.swift
//  NasaAPOD-MVP
//
//  Created by Ashley Ng on 4/22/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit
import RxSwift

class NasaPhotoDetailViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var photoTitle: UILabel!
    @IBOutlet private var date: UILabel!
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    
    private let photoInfo: NasaPhotoInfo
    private let disposeBag = DisposeBag()
    
    init(photoInfo: NasaPhotoInfo) {
        self.photoInfo = photoInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoTitle.text = photoInfo.title
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        formatter.string(from: photoInfo.date)
        self.date.text = formatter.string(from: photoInfo.date)
        self.textView.text = photoInfo.description
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        ImageCache.shared.imageFor(url: photoInfo.photoUrl)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.loadingIndicator.stopAnimating()
                self?.loadingIndicator.isHidden = true
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
}
