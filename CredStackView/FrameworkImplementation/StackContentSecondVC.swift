//
//  StackContentVC.swift
//  CredStackView
//
//  Created by Gourav Kumar on 06/02/24.
//

import UIKit

class StackContentSecondVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func setColor(color:UIColor){
        self.view.backgroundColor = color
    }
    

}
extension StackContentSecondVC:StackViewCTAProtocol {
    func ctaTapped(stackManager: StackViewManager?) {
        let secondVC = StackContentThirdVC()
        secondVC.setColor(color: .orange)
        stackManager?.showStackVC(close: { frame in
            return secondVC
        })
    }
    
   
    
    var ctaText: String {
        return "Second CTA"
    }
    
    var ctaColor: UIColor? {
        return UIColor.magenta
    }
    
    
}
