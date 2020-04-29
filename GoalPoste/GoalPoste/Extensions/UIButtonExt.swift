//
//  UIButtonExt.swift
//  GoalPoste
//
//  Created by bennoui ihab on 4/24/20.
//  Copyright © 2020 bennoui ihab. All rights reserved.
//

import UIKit

extension UIButton {
    func setSelectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    }
    func setDeselectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.4922404289, green: 0.7722371817, blue: 0.4631441236, alpha: 1)
    }
}
