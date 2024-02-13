//
//  ViewController.swift
//  CredStackView
//
//  Created by Gourav Kumar on 06/02/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button = UIButton(frame: CGRect(x: view.frame.width / 2 - 50, y: view.frame.height / 2, width: 100 , height: 50))
        button.addTarget(self, action: #selector(showMainStack), for: .touchUpInside)
        self.view.backgroundColor = .brown
        button.backgroundColor = .blue
        button.setTitle("Show Stack", for: .normal)
        view.addSubview(button)
    }
    @objc func showMainStack(){
        let stack = StackViewManager()
        let mainVC = StackContentFirstVC()
        mainVC.setColor(color: .cyan)
        stack.modalPresentationStyle = .fullScreen
        present(stack, animated: true)
        stack.showStackVC(close: { frame in
            return mainVC
        })
    }


}

