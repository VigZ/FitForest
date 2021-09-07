//
//  StoreFrontView.swift
//  FitForest
//
//  Created by Kyle Vigorito on 9/6/21.
//

import UIKit

class StoreFrontView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var delegate:UIViewController!

    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }

    private func setupView() {
        backgroundColor = .white
        setupLayout()
    }

    private func setupLayout() {
      
    }

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }
}
