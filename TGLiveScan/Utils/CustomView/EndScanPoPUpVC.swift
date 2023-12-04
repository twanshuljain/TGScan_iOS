//
// EndScanPoPUpVC.swift
// TicketGateway
//
// Created by Apple on 27/06/23.
//
import UIKit
protocol AlertAction: AnyObject {
    func alertYesaction()
}
class EndScanPoPUpVC: UIViewController {
    //MARK: - Outltes
    @IBOutlet weak var imgBackGrund: UIImageView!
    @IBOutlet weak var lblEndScan: UILabel!
    @IBOutlet weak var lblTitleDescription: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: CustomButtonGradiant!
    @IBOutlet weak var btnOkay: UIButton!
    @IBOutlet weak var viewForOkayButton: UIView!
    @IBOutlet weak var stackViewForButtons: UIStackView!
    //MARK: - Variables
    weak var delegate: AlertAction?
    var strMsgForTitle = ""
    var strMsgForDescription = ""
    var isStackViewHidden: Bool?
    var isViewForOkayButtonHidden: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFont()
        self.setUI()
        self.lblEndScan.text = strMsgForTitle
        self.lblTitleDescription.text = strMsgForDescription
    }
}
//MARK: - Instance Method
extension EndScanPoPUpVC {
    func setFont() {
        self.viewForOkayButton.isHidden = isViewForOkayButtonHidden ?? false
        self.stackViewForButtons.isHidden = isStackViewHidden ?? false
        self.lblEndScan.font = UIFont.setFont(fontType: .semiBold, fontSize: .twentyFour)
        self.lblEndScan.textColor = UIColor.setColor(colorType: .titleColourDarkBlue)
        self.lblTitleDescription.font = UIFont.setFont(fontType: .regular, fontSize: .fourteen)
        self.lblTitleDescription.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.btnYes.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.btnYes.titleLabel?.textColor = UIColor.setColor(colorType: .tgBlack)
        self.btnNo.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.btnNo.titleLabel?.textColor = UIColor.setColor(colorType: .tgBlack)
        self.btnOkay.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.btnOkay.titleLabel?.textColor = UIColor.setColor(colorType: .tgBlack)
    }
}
//MARK: - Instance Method
extension EndScanPoPUpVC {
    func setUI() {
        [self.btnYes, self.btnNo, self.btnOkay].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        }
    }
    @objc func buttonPressed(sender: UIButton) {
        switch sender {
        case btnYes:
            self.btnYesAction()
        case btnNo:
            self.btnNoAction()
        case btnOkay:
            self.btnNoAction() // For dismiss the view
        default:
            break
        }
    }
    func btnYesAction() {
        self.dismiss(animated: true)
        self.delegate?.alertYesaction()
    }
    func btnNoAction() {
        self.dismiss(animated: true)
    }
}
