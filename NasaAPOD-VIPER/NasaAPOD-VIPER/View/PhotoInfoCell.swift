//
//  PhotoInfoCell.swift
//  NasaAPOD-VIPER
//
//  Created by Ashley Ng on 5/13/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit

class PhotoInfoCell: UITableViewCell {

    @IBOutlet private var nasaImageView: UIImageView!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var date: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func startAnimating() {
        self.loadingIndicator.startAnimating()
        self.loadingIndicator.isHidden = false
    }
    
    func stopAnimating() {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
    }
    
    func setImage(image: UIImage) {
        self.nasaImageView.image = image
    }
    
    func configure(title: String, date: Date) {
        self.title.text = title
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        self.date.text = formatter.string(from: date)
    }
    
}
