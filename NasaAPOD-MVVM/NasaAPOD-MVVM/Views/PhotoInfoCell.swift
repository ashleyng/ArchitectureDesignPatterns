//
//  PhotoInfoCell.swift
//  NasaAPOD-MVVM
//
//  Created by Ashley Ng on 4/7/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit
import RxSwift

class PhotoInfoCell: UITableViewCell {
    @IBOutlet private weak var nasaImageView: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    private var viewModel: PhotoInfoViewModel?
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with viewModel: PhotoInfoViewModel) {
        self.viewModel = viewModel
        viewModel.rx_isLoading
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.imageData()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.nasaImageView.image = UIImage(data: data as Data)
            })
            .disposed(by: disposeBag)
        
        self.title.text = viewModel.title
        self.date.text = viewModel.date
    }
    
}

