//
//  PanelViewController.swift
//  Stocks
//
//  Created by Emir Alkal on 17.01.2023.
//

import UIKit

final class PanelViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setUpGrabberView()
    }
    
    private func setUpGrabberView() {
        let grabberView = UIView(frame: .init(x: 0, y: 0, width: 100, height: 10))
        grabberView.backgroundColor = .label
        view.addSubview(grabberView)
        grabberView.center = .init(x: view.center.x, y: 5)
    }
}
