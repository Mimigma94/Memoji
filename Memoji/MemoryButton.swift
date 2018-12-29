//
//  MemoryButton.swift
//  Memoji
//
//  Created by Selina Kröcker on 24.10.18.
//  Copyright © 2018 Selina Piper. All rights reserved.
//

import UIKit

class MemoryButton: UIButton {

    //--------------------------------------------------
    // MARK: - Properties
    //--------------------------------------------------
    
    var flipped = false {
        willSet {
            if newValue {
                setTitleColor(UIColor.black, for: .normal)
            } else {
                setTitleColor(UIColor.clear, for: .normal)
            }
        }
    }
    //--------------------------------------------------
    // MARK: - Lifecycle
    //--------------------------------------------------
    
    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width/10
        layer.masksToBounds = true
        backgroundColor = UIColor.white 
    }
}
