//
//  UIView+AddSubViews.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/23.
//

import UIKit

extension UIView {
    
    /// Add sub views with array
    ///
    /// - Parameter subViews: An Array of subViews which need to be added.
    /// - Parameter intoContraints: If translates into constraints.
    /// - Returns: Void.
    func addSubViews(_ views: [UIView], intoContraints: Bool = false) {
        views.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = intoContraints
        }
    }
}
