//
//  MainView.swift
//  FitForest
//
//  Created by Kyle Vigorito on 3/22/21.
//

import UIKit

class MainView: UIView {

    lazy var topContainer: TopContainer = {
        let top = TopContainer()
        top.translatesAutoresizingMaskIntoConstraints = false
        return top
    }()
    
    lazy var bottomContainer: BottomContainer = {
        let bottom = BottomContainer()
        bottom.translatesAutoresizingMaskIntoConstraints = false
        return bottom
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
        addSubview(topContainer)
        addSubview(bottomContainer)
    }

    private func setupLayout() {
      NSLayoutConstraint.activate([
        topContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
        topContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        topContainer.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
        topContainer.heightAnchor.constraint(equalToConstant: 600),

        bottomContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
        bottomContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        bottomContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
        bottomContainer.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
      ])
    }

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }

}
