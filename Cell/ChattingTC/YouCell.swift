//
//  YouCell.swift
//  ume
//
//  Created by shin seunghyun on 2020/07/28.
//  Copyright © 2020 haii. All rights reserved.
//

import UIKit

class YouCell: UITableViewCell {

    @IBOutlet weak var chattingBubble: UIView!
    @IBOutlet weak var chattingTextLabel: UILabel!
    @IBOutlet weak var youCellRightConstraint: NSLayoutConstraint!
    
    var isGIFShown: Bool?

    var gifImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        setGifImageView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        youCellRightConstraint.constant = self.frame.width / 2
        chattingBubble.layer.cornerRadius = 16
        chattingBubble.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    private func setGifImageView() {
        self.addSubview(gifImageView)
        gifImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        gifImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        gifImageView.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor, constant: -(self.frame.width / 2)).isActive = true
        gifImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        gifImageView.isHidden = true
    }


}

