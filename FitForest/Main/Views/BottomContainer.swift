//
//  BottomContainer.swift
//  FitForest
//
//  Created by Kyle Vigorito on 3/22/21.
//

import UIKit

class BottomContainer: UIView {

    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }

    private func setupView() {
        backgroundColor = .systemPurple
        setupLayout()
    }

    private func setupLayout() {

    }

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }
}
