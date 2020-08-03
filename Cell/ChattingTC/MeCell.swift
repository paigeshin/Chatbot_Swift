//
//  MeCell.swift
//  ume
//
//  Created by shin seunghyun on 2020/07/28.
//  Copyright © 2020 haii. All rights reserved.
//

import UIKit

class MeCell: UITableViewCell {

    @IBOutlet weak var chattingBubble: UIView!
    @IBOutlet weak var chattingTextLabel: UILabel!
    @IBOutlet weak var meCellLeftConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        chattingBubble.layer.cornerRadius = 16
        chattingBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        
        meCellLeftConstraint.constant = self.frame.width / 2
    }
    
}


