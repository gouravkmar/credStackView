//
//  StackViewController.swift
//  CredStackView
//
//  Created by Gourav Kumar on 06/02/24.
//

import UIKit

protocol StackViewCTAProtocol :AnyObject  {
    func ctaTapped(stackManager : StackViewManager?)
    var ctaText: String { get }
    var ctaColor : UIColor? {get}
}
protocol StackTapProtocol:AnyObject {
    func stackExpandTapped(index : Int)
    func dismissButtonTapped(index:Int)
    
}
class StackView : UIView {
    var index : Int
    var childView : UIView
    weak var delegate : (StackTapProtocol)?
    
    init(frame: CGRect,index :Int,view:UIView) {
        self.index = index
        self.childView = view
        super.init(frame: frame)
        childView.layer.cornerRadius = 10.0
        addSubview(childView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class StackViewManager: UIViewController {
    var viewStack : [StackView] = []
    var currentFrame  = CGRectZero
    let gapBetweenViews = 100.0
    let bottomCTAHeight = 100.0
    var ctaButton = UIButton(frame: CGRectZero)
    weak var delegate : StackViewCTAProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        currentFrame = view.frame
        view.addSubview(ctaButton)
        view.backgroundColor = .gray
    }
    
    
    func getAvailableFrame()->CGRect{
        let  requiredHeight = (currentFrame.origin.y + 2 * gapBetweenViews)
        let availableHeight = (view.frame.height - bottomCTAHeight)
        if  availableHeight >= requiredHeight {
            var newframe = view.frame
            newframe.size.height = newframe.height - gapBetweenViews
            newframe = newframe.offsetBy(dx: 0, dy: gapBetweenViews)
            return newframe
        }
        return CGRectZero
    }
    func updateAvailableFrame(){
        let stackCount = viewStack.count
        var newframe = view.frame
        newframe.size.height = newframe.height - gapBetweenViews * Double(stackCount)
        newframe = newframe.offsetBy(dx: 0, dy: gapBetweenViews * Double(stackCount))
        currentFrame = newframe
        
    }
    
    func showStackVC(close:(CGRect)->UIView){
        let nextframe = getAvailableFrame()
        guard nextframe != CGRectZero else {
            return
        }
        let view = close(nextframe)
        let stackView = StackView(frame: nextframe, index: viewStack.count, view: view)
        viewStack.append(stackView)
        let visibleFrame = stackView.frame.offsetBy(dx: 0, dy: nextframe.origin.y)
        stackView.frame = visibleFrame
        self.view.addSubview(stackView)
        
        
    }
    
    func setupCTAButton(view : UIView){
        guard let newView = view as? StackViewCTAProtocol else {
            ctaButton.frame = CGRectZero
            return
        }
        ctaButton.setTitle(newView.ctaText, for: .normal)
        ctaButton.frame = CGRect(x: 0, y: self.view.frame.height - bottomCTAHeight, width: view.frame.width, height: bottomCTAHeight)
        ctaButton.backgroundColor = newView.ctaColor ?? UIColor.systemBackground
        ctaButton.addTarget(self, action: #selector(ctaButtonTap), for: .touchUpInside)
        
    }
    @objc func ctaButtonTap(){
        if let topView = viewStack.last as? StackViewCTAProtocol {
            topView.ctaTapped(stackManager: self)
        }
        
    }

}

extension StackViewManager : StackTapProtocol  {
    func stackExpandTapped(index: Int) {
        for view in viewStack {
            if view.index > index {
                view.removeFromSuperview() //animate this
                view.frame = view.frame.offsetBy(dx: 0, dy: -((Double(index) * gapBetweenViews)))
            }
        }
        viewStack.remove(at: index)
        updateAvailableFrame()
    }
    
    func dismissButtonTapped(index: Int) {
        for view in viewStack {
            if view.index > index {
                view.removeFromSuperview() //animate this
            }
        }
        viewStack.remove(at: index)
        updateAvailableFrame()
    }
    
    
    
    
}
