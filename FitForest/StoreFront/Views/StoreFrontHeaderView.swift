//
//  StoreFrontHeaderView.swift
//  FitForest
//
//  Created by Kyle Vigorito on 9/7/21.
//

import UIKit

class StoreFrontHeaderView: UIView {
    
    let headerImageView: UIImageView = {
        let image = UIImage(named: "runyun.jpeg")!
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }

    private func setupView() {
        backgroundColor = .systemGreen
        
        setupLayout()
    }

    private func setupLayout() {

    }

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }

}
