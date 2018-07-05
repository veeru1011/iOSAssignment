//
//  FactViewCell.swift
//  iOSAssigment
//
//  Created by VEER TIWARI on 7/5/18.
//  Copyright © 2018 VBT. All rights reserved.
//

import UIKit

class FactViewCell: UITableViewCell {

    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    let profileImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = 2
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
            self.profileImageView.image = nil
            self.titleLabel.text  = ""
            self.descriptionLabel.text  = ""
            self.profileImageView.image = nil
            guard let factItem = fact else { return }
            if let title = factItem.title {
                titleLabel.text = title
                if let description = factItem.descriptions {
                    descriptionLabel.text = " \(description) "
                }
                
                if let imageUrl = factItem.imageUrl {
                    self.profileImageView.imageFromServerURL(urlString: imageUrl)
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

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let marginGuide = contentView.layoutMarginsGuide
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        
        profileImageView.centerYAnchor.constraint(equalTo:marginGuide.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo:marginGuide.leadingAnchor, constant:5).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant:70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant:70).isActive = true
        
        
        titleLabel.topAnchor.constraint(equalTo:marginGuide.topAnchor,constant:10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant:10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor,constant:5).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant:10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo:marginGuide.trailingAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo:marginGuide.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}
