//
//  CustomSearchBar.swift
//  TicketGateway
//
//  Created by Dr.Mac on 26/04/23.

import UIKit

protocol CustomSearchMethodsDelegate {
   func leftButtonPressed(_ sender:UIButton)
   func rightButtonPressed(_ sender:UIButton)
   func filterButtonPressed(_ sender:UIButton)
}

extension CustomSearchMethodsDelegate{
    func leftButtonPressed(_ sender:UIButton) {}
    func rightButtonPressed(_ sender:UIButton) {}
    func filterButtonPressed(_ sender:UIButton) {}
}

enum CustomSearchBarEnum:Int{
    case home = 0
    case costume = 1
}

class CustomSearchBar: UIView {
    var searchTextPlaceholder = "Search event..."
    @IBOutlet weak var vwLocation: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var wtBtnMenu:NSLayoutConstraint!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var imgMap: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnLocation:UIButton!
    @IBOutlet weak var locationView:UIView!
    @IBOutlet weak var btnFilter:UIButton!
    @IBOutlet weak var wtBtnFilter:NSLayoutConstraint!
    
    var delegate:CustomSearchMethodsDelegate?
    var customSearchBarEnum:CustomSearchBarEnum = .home
    
    let nibName = "CustomSearchBar"
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
            txtSearch.attributedPlaceholder = NSAttributedString(string:searchTextPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.setColor(colorType: .placeHolder)])
            txtSearch.autocorrectionType = .no
            self.setUpView()
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
            self.setUpView()
        }
        private func commonInit() {
          
            guard let view = loadViewFromNib() else { return }
            view.frame = self.bounds
           self.addSubview(view)
        }
        
        private func loadViewFromNib() -> UIView? {
            let nib = UINib(nibName: nibName, bundle: nil)
            return nib.instantiate(withOwner: self, options: nil).first as? UIView
        }
    
    func setUpView(){
        if self.customSearchBarEnum == .costume{
            wtBtnMenu.constant = 0
            wtBtnFilter.constant = 50
            self.btnFilter.isHidden = false
            self.locationView.isHidden = true
            self.backgroundColor = UIColor.setColor(colorType: .bgPurpleColor)
        }else{
            wtBtnFilter.constant = 0
            self.btnFilter.isHidden = true
            self.locationView.isHidden = false
            wtBtnMenu.constant = 40
            self.backgroundColor = UIColor.setColor(colorType: .borderLineColour)
        }
    }
    
    @IBAction func btnFilter(_ sender: UIButton) {
        self.delegate?.filterButtonPressed(sender)
    }
    
    
    @IBAction func btnLeft(_ sender: UIButton) {
        self.delegate?.leftButtonPressed(sender )
    }

    @IBAction func btnRight(_ sender: UIButton) {
        self.delegate?.rightButtonPressed(sender )
    }
}
