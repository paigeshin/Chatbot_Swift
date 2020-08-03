//
//  ButtonCC.swift
//  ume
//
//  Created by shin seunghyun on 2020/07/29.
//  Copyright © 2020 haii. All rights reserved.
//

import UIKit

protocol ButtonCCDelegate {
    
    func notifyChattingButtonLabelClicked(text: String)
    
}


class ButtonCC: UICollectionViewCell {
    
    @IBOutlet weak var chattingButtonContainerView: UIView!
    @IBOutlet weak var chattingButtonLabel: UILabel!
    
    var delegate: ButtonCCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chattingButtonContainerView.isUserInteractionEnabled = true
        chattingButtonLabel.isUserInteractionEnabled = true
        chattingButtonLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chattingButtonContainerView.layer.cornerRadius = 18
        chattingButtonContainerView.layer.borderWidth = 2
        chattingButtonContainerView.layer.borderColor = KDesign.Asset.Color.DARK_GREEN_BLUE.cgColor
    }
    
    @objc private func buttonTapped() {
        guard let chattingMessage: String = chattingButtonLabel.text else { return }
        delegate?.notifyChattingButtonLabelClicked(text: chattingMessage)
    }

}
