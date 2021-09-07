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
    
    lazy var header: StoreFrontHeaderView = {
        let header = StoreFrontHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
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
        addSubview(header)
        backgroundColor = .white
        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            header.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            header.heightAnchor.constraint(equalToConstant: 270)
        ])
    }

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }
}
