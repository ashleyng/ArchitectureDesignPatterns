//
//  NasaPhotoDetailsViewController.swift
//  NasaAPOD-MVVM
//
//  Created by Ashley Ng on 4/7/18.
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
    
    private let viewModel: PhotoInfoViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: PhotoInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoTitle.text = viewModel.title
        self.date.text = viewModel.date
        self.textView.text = viewModel.description
        
        viewModel.rx_isLoading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                    self?.loadingIndicator.isHidden = false
                } else {
                    self?.loadingIndicator.stopAnimating()
                    self?.loadingIndicator.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.imageData()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] imageData in
                self?.imageView.image = UIImage(data: imageData as Data)
            })
            .disposed(by: disposeBag)
    }
}
