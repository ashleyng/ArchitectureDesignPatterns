//
//  PhotoInfoCell.swift
//  NasaAPOD-MVP
//
//  Created by Ashley Ng on 4/22/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit

class PhotoInfoCell: UITableViewCell {

    @IBOutlet weak var nasaImageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
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
