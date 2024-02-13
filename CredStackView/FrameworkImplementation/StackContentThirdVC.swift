//
//  StackContentVC.swift
//  CredStackView
//
//  Created by Gourav Kumar on 06/02/24.
//

import UIKit

class StackContentThirdVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func setColor(color:UIColor){
        self.view.backgroundColor = color
    }
    

}
extension StackContentThirdVC:StackViewCTAProtocol {
    func ctaTapped(stackManager: StackViewManager?) {
        let secondVC = StackContentFourthVC()
        secondVC.setColor(color: .green)
        stackManager?.showStackVC(close: { frame in
            return secondVC
        })
    }
    
   
    
    var ctaText: String {
        return "Third CTA"
    }
    
    var ctaColor: UIColor? {
        return UIColor.lightGray
    }
    
    
}
