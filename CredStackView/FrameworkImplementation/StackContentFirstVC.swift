//
//  StackContentVC.swift
//  CredStackView
//
//  Created by Gourav Kumar on 06/02/24.
//

import UIKit

class StackContentFirstVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func setColor(color:UIColor){
        self.view.backgroundColor = color
    }
    

}
extension StackContentFirstVC:StackViewCTAProtocol {
    func ctaTapped(stackManager: StackViewManager?) {
        let secondVC = StackContentSecondVC()
        secondVC.setColor(color: .blue)
        stackManager?.showStackVC(close: { frame in
            return secondVC
        })
    }
    
   
    
    var ctaText: String {
        return "First CTA"
    }
    
    var ctaColor: UIColor? {
        return UIColor.green
    }
    
    
}
