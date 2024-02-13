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
enum ViewState{
    case expanded,collapsed
}
class ContainerView : UIViewController {
    var index : Int
    var childView : UIViewController
    weak var delegate : (StackTapProtocol)?
    var state : ViewState = .collapsed
    var expandButton = UIButton(frame: CGRectZero)
    init(frame: CGRect,index :Int,view:UIViewController) {
        self.index = index
        self.childView = view
        
        super.init(nibName: nil, bundle: nil)
        self.view.frame = frame
        childView.view.layer.cornerRadius = 10.0
        self.view.addSubview(childView.view)
        expandButton = UIButton(frame: CGRect(x: frame.width - 70, y: 20, width: 20, height: 20))
        expandButton.addTarget(self, action: #selector(dismissTap), for: .touchUpInside)
        expandButton.setImage(UIImage(named: "arrowDown"), for: .normal)
        expandButton.imageView?.contentMode = .scaleAspectFit
        self.view.addSubview(expandButton)
        let gestRec = UITapGestureRecognizer(target: self, action: #selector(expandTap))
        gestRec.view?.frame = CGRect(x: 0, y: 0, width: Int(frame.width) - 100, height: 100)
        self.view.addGestureRecognizer(gestRec)
        hideExpandButton()
    }
    func showExpandButton(){
        expandButton.isHidden = false
    }
    func hideExpandButton(){
        expandButton.isHidden = true
    }
    @objc func expandTap(){
        delegate?.stackExpandTapped(index: index)
        if state == .expanded{
            hideExpandButton()
        }
        
    }
    @objc func dismissTap(){
        delegate?.dismissButtonTapped(index: index)
        hideExpandButton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class StackViewManager: UIViewController {
    var viewStack : [ContainerView] = []
    var currentFrame  = CGRectZero
    let gapBetweenViews = 100.0
    let bottomCTAHeight = 80.0
    var ctaButton = UIButton(frame: CGRectZero)
    weak var delegate : StackViewCTAProtocol?
    var expandedViewIndex = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        currentFrame = view.frame
        view.addSubview(ctaButton)
        view.backgroundColor = .gray
        let crossButton = UIButton(frame: CGRect(x: 20, y: 60, width: 30, height: 30))
        crossButton.setImage(UIImage(named: "circle.cross"), for: .normal)
        crossButton.imageView?.contentMode = .scaleAspectFill
        crossButton.addTarget(self, action: #selector(crossTap), for: .touchUpInside)
        view.addSubview(crossButton)
    }
    
    
    func getAvailableFrame()->CGRect{
        let stackCount = viewStack.count
        let offset = 100.0
        var newframe = view.frame.offsetBy(dx: 0, dy: gapBetweenViews * Double(stackCount) + offset)

        let  requiredHeight = (newframe.origin.y + 2 * gapBetweenViews)
        let availableHeight = (view.frame.height - bottomCTAHeight)
        if  availableHeight >= requiredHeight {
            return newframe
        }
        return CGRectZero
    }
    @objc func crossTap(){
        self.dismiss(animated: true)
        viewStack.removeAll()
    }
    
    func showStackVC(close:(CGRect)->UIViewController){
        let nextframe = getAvailableFrame()
        if expandedViewIndex != -1 {
            stackExpandTapped(index: expandedViewIndex)
        }
        guard nextframe != CGRectZero else {
            return
        }
        if !viewStack.isEmpty , let lastV = viewStack.last {
            lastV.showExpandButton()
        }
        let viewC = close(nextframe)
        let stackView = ContainerView(frame:view.frame.offsetBy(dx: 0, dy: view.frame.height - bottomCTAHeight) , index: viewStack.count, view: viewC)
        viewStack.append(stackView)
        self.view.addSubview(stackView.view)
        UIView.animate(withDuration: 0.5, animations: {
            stackView.view.frame = nextframe
        })
        stackView.delegate = self
        setupCTAButton(viewC: viewC)
    }
    
    func setupCTAButton(viewC : UIViewController){
        guard let newView = viewC as? StackViewCTAProtocol else {
            ctaButton.frame = CGRectZero
            return
        }
        self.view.bringSubviewToFront(ctaButton)
        ctaButton.setTitle(newView.ctaText, for: .normal)
        ctaButton.frame = CGRect(x: 0, y: self.view.frame.height - bottomCTAHeight, width: viewC.view.frame.width, height: bottomCTAHeight)
        ctaButton.backgroundColor = newView.ctaColor ?? UIColor.systemBackground
        ctaButton.addTarget(self, action: #selector(ctaButtonTap), for: .touchUpInside)
        
    }
    @objc func ctaButtonTap(){
        if let topView = viewStack.last?.childView ,let delegate = topView as? StackViewCTAProtocol {
            delegate.ctaTapped(stackManager: self)
        }
        
    }
    

}

extension StackViewManager : StackTapProtocol  {
    func stackExpandTapped(index: Int) {
        let fr = viewStack[index]
        if fr.state == .collapsed {
            viewStack.removeAll(where: {cont in
                if cont.index > index {
                    UIView.animate(withDuration: 0.5, animations: {
                        cont.view.frame.origin.y += cont.view.frame.height
                    }, completion: {_ in 
                        cont.view.removeFromSuperview()
                    })
                    return true
                }
                return false})
            let stackCount = viewStack.count
            
            var newframe = fr.view.frame
            newframe.size.height = newframe.height + gapBetweenViews * Double(stackCount - 1)
            newframe = newframe.offsetBy(dx: 0, dy: -gapBetweenViews * Double(stackCount - 1))
            fr.view.frame = newframe
            fr.state = .expanded
            expandedViewIndex = index
        }else {
            expandedViewIndex = -1
            let stackCount = viewStack.count
            var newframe = fr.view.frame
            newframe.size.height = newframe.height + self.gapBetweenViews * Double(stackCount)
            newframe = newframe.offsetBy(dx: 0, dy: self.gapBetweenViews * Double(stackCount - 1))
            UIView.animate(withDuration: 0.5, animations: {
                fr.view.frame = newframe
            })
            fr.state = .collapsed
        }
        setupCTAButton(viewC: fr.childView)
    }
    
    func dismissButtonTapped(index: Int) {
        viewStack.removeAll(where: {cont in
            if cont.index > index {
                UIView.animate(withDuration: 0.5, animations: {
                    cont.view.frame.origin.y += cont.view.frame.height
                }, completion: {_ in
                    cont.view.removeFromSuperview()
                })
                return true
            }
            return false})
        let fr = viewStack[index]
        setupCTAButton(viewC: fr.childView)
    }
}

