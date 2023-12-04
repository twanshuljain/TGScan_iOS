//
// NavigationBarView.swift
// Iscra
//
// Created by Apple on 12/04/2023
import UIKit


protocol NavigationBarViewDelegate {
    func navigationBackAction()
    func navigationRightButtonAction()
}

extension NavigationBarViewDelegate {
    func navigationBackAction() {}
    func navigationRightButtonAction() {}
}


class NavigationBarView: UIView {
    
    
    @IBOutlet weak var navView:UIView!
    @IBOutlet weak var vwSkip: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnRight: UIButton!
    @IBOutlet weak var btnSecRight: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewContent: UIView!
    @IBOutlet weak var lblSeprator: UILabel!
    @IBOutlet weak var lblDiscripation: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var vwBorder: UIView!
    @IBOutlet weak var lblSeprator1: UILabel!
    
    let XIB_NAME = "NavigationBarView"
    var delegateBarAction: NavigationBarViewDelegate!
    var navViewbackgroundColor: UIColor?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    func commonInit() {
        Bundle.main.loadNibNamed(XIB_NAME, owner: self, options: nil)
        viewContent.fixInView(self)
        [btnRight, btnBack,btnSecRight,btnSkip].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
        btnBack.showsTouchWhenHighlighted = false
        btnBack.isHidden = true
        btnRight.isHidden = true
        btnSecRight.isHidden = true
        lblSeprator.isHidden = true
        lblDiscripation.isHidden = true
        btnSkip.isHidden = true
        vwBorder.isHidden = true
        vwSkip.isHidden = true
    }
    func setBackgroundColor(){
        navView.backgroundColor = (navViewbackgroundColor == nil ? UIColor.setColor(colorType: .white) : UIColor.setColor(colorType: .btnDarkBlue))
    }
}
extension NavigationBarView {
    @objc func buttonPressed(_ sender: UIButton) {
        switch sender {
        case btnBack:
            self.backClick()
        case btnRight:
            self.rightButtonClick()
        case btnSecRight:
            self.secRightButtonClick()
        case btnSkip:
            self.btnSkipButtonClick()
        default:
            break
        }
    }
    private func backClick() {
        print("button clicked.")
        delegateBarAction?.navigationBackAction()
    }
    private func rightButtonClick() {
        delegateBarAction?.navigationRightButtonAction()
    }
    private func secRightButtonClick() {
        //   delegateBarAction?.navigationRightButtonAction?()
    }
    private func btnSkipButtonClick() {
        delegateBarAction?.navigationRightButtonAction()
    }
}
extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
