//
//  UIView+.swift
//  Stocks
//
//  Created by Emir Alkal on 17.01.2023.
//

import UIKit

extension UIView {
    var width: CGFloat {
        frame.size.width
    }
    
    var height: CGFloat {
        frame.size.height
    }
    
    var left: CGFloat {
        frame.origin.x
    }
    
    var right: CGFloat {
        left + width
    }
    
    var top: CGFloat {
        frame.origin.y
    }
    
    var bottom: CGFloat {
        top + height
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { v in
            addSubview(v)
        }
    }
}
