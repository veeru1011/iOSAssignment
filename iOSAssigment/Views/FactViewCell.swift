//
//  FactViewCell.swift
//  iOSAssigment
//
//  Created by VEER TIWARI on 7/5/18.
//  Copyright © 2018 VBT. All rights reserved.
//

import UIKit
import SDWebImage

class FactViewCell: UITableViewCell {
    
    let displayImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = 1
        img.clipsToBounds = true
        return img
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor =  #colorLiteral(red: 0.2549019608, green: 0.2745098039, blue: 0.3019607843, alpha: 1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var fact: Fact? {
        didSet {
            self.titleLabel.text  = " "
            self.descriptionLabel.text  = " "
            self.displayImageView.image = nil
            guard let factItem = fact else { return }
            if let title = factItem.title {
                titleLabel.text = title
                if let description = factItem.descriptions {
                    descriptionLabel.text = " \(description) "
                }
                
                if let imageUrl = factItem.imageUrl {
                    self.displayImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        self.contentView.addSubview(displayImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        
        displayImageView.topAnchor.constraint(equalTo:marginGuide.topAnchor).isActive = true
        displayImageView.leadingAnchor.constraint(equalTo:marginGuide.leadingAnchor, constant:5).isActive = true
        displayImageView.widthAnchor.constraint(equalToConstant:70).isActive = true
        displayImageView.heightAnchor.constraint(equalToConstant:70).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo:marginGuide.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo:self.displayImageView.trailingAnchor, constant:10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor,constant:5).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo:self.displayImageView.trailingAnchor, constant:10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo:marginGuide.trailingAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo:marginGuide.bottomAnchor,constant: -20).isActive = true
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
