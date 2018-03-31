//
//  NasaPhotoDetailViewController.swift
//  NasaAPOD-MVC
//
//  Created by Ashley Ng on 3/31/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit
import RxSwift

class NasaPhotoDetailViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var photoTitle: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
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
        ImageCache.shared.imageFor(url: photoInfo.photoUrl)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { image in
                self.imageView.image = image
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
