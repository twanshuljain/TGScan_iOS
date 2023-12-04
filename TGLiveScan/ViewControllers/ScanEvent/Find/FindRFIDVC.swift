//
//  FindRFIDVC.swift
//  TicketGateway
//
//  Created by Apple on 22/06/23.

import UIKit
import SDWebImage

class FindRFIDVC: UIViewController {
    // MARK: - Oulets
    @IBOutlet weak var lblScan: UILabel!
    @IBOutlet weak var imgScan: UIImageView!
    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var lblFindRfid: UILabel!
    @IBOutlet weak var imgFindRfid: UIImageView!
    @IBOutlet weak var btnFindRfid: UIButton!
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lbl3Tix: UILabel!
    @IBOutlet weak var btnTicket: CustomButtonGradiant!
    @IBOutlet weak var lblSunburnReload: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblKeepCloserYourDevice: UILabel!
    @IBOutlet weak var imgConnect: UIImageView!
    @IBOutlet weak var btnEndScan: UIButton!
    @IBOutlet weak var lblAccepted: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblRejected: UILabel!
    @IBOutlet weak var connectedStackView: UIStackView!
    @IBOutlet weak var lblTickteVerified: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    // MARK: - Variables
    let viewModel = FindRFIDViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFont()
        self.setUI()
    }
}
// MARK: -
extension FindRFIDVC {
    func setFont() {
        if viewModel.isConnected {
            connectedStackView.isHidden = false
            lblKeepCloserYourDevice.isHidden = true
            imgConnect.isHidden = true
        } else {
            connectedStackView.isHidden = true
            showToast(message: SOMETHING_WENT_WRONG)
        }
        self.lblScan.font = UIFont.setFont(fontType: .medium, fontSize: .twelve)
        self.lblScan.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.imgScan.image = UIImage(named: SCAN_UNSELECTED_ICON)
        self.lblFindRfid.font = UIFont.setFont(fontType: .medium, fontSize: .twelve)
        let gradient = getGradientLayer(bounds: view.bounds)
        self.lblFindRfid.textColor = gradientColor(bounds: view.bounds, gradientLayer: gradient)
        self.imgFindRfid.image = UIImage(named: FIND_SELECTED_ICON)
        self.lblSearch.font = UIFont.setFont(fontType: .medium, fontSize: .twelve)
        self.lblSearch.textColor = UIColor.setColor(colorType: .lblTextPara)
        imgSearch.image = UIImage(named: SEARCH_UNSELECT_ICON)
        self.lbl3Tix.font = UIFont.setFont(fontType: .regular, fontSize: .twelve)
        self.lbl3Tix.textColor = UIColor.setColor(colorType: .titleColourDarkBlue)
        self.lblSunburnReload.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.lblSunburnReload.textColor = UIColor.setColor(colorType: .titleColourDarkBlue)
        self.lblDate.font = UIFont.setFont(fontType: .regular, fontSize: .twelve)
        self.lblDate.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.lblKeepCloserYourDevice.font = UIFont.setFont(fontType: .regular, fontSize: .sixteen)
        let lblGradient = getGradientLayer(bounds: view.bounds)
        lblKeepCloserYourDevice.textColor = gradientColor(bounds: view.bounds, gradientLayer: lblGradient)
        self.btnEndScan.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.btnEndScan.titleLabel?.textColor = UIColor.setColor(colorType: .tgRed)
        self.lblAccepted.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.lblAccepted.textColor = UIColor.setColor(colorType: .tgGreen)
        self.lblTotal.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.lblTotal.textColor = UIColor.setColor(colorType: .titleColourDarkBlue)
        self.lblRejected.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.lblRejected.textColor = UIColor.setColor(colorType: .tgRed)
        lblTickteVerified.font = UIFont.setFont(fontType: .regular, fontSize: .sixteen)
        lblTickteVerified.textColor = UIColor.setColor(colorType: .lblTextPara)
        lblSunburnReload.text = viewModel.updateTicketModel.eventName
        lblDate.text = viewModel.updateTicketModel.date
        if let url = (APIHandler.shared.s3URL + viewModel.getScanTicketDetails.imageUrl).getCleanedURL() {
            self.profileImage.sd_setImage(with: url, placeholderImage: UIImage(named: "Profile_ip"), options: SDWebImageOptions.continueInBackground)
        } else {
            self.profileImage.image = UIImage(named: "Profile_ip")
        }
    }
}
// MARK: - Instance Method
extension FindRFIDVC {
    func setUI() {
        [self.btnSearch, self.btnScan, self.btnFindRfid, self.btnTicket].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        }
    }
    @objc func buttonPressed(sender: UIButton) {
        switch sender {
        case btnScan:
            self.btnScanAction()
        case btnFindRfid:
            self.btnFindRfidAction()
        case btnSearch:
            self.btnSearchAction()
        case btnTicket:
            self.btnTicketAction()
        default:
            break
        }
    }
    func btnScanAction() {
        if let scannerVC = createView(storyboard: .main, storyboardID: .ScannerVC) as? ScannerVC {
            // Send data back to previous screen
            scannerVC.viewModel.updateTicketModel = viewModel.updateTicketModel
            self.navigationController?.pushViewController(scannerVC, animated: false)
        }
    }
    func btnFindRfidAction() {
    }
    func btnSearchAction() {
        if let searchVC = createView(storyboard: .main, storyboardID: .SearchVC) as? SearchVC {
            // Send data back to previous screen
            searchVC.viewModel.updateTicketModel = viewModel.updateTicketModel
            self.navigationController?.pushViewController(searchVC, animated: false)
        }
    }
    func btnTicketAction() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: SelectTicketTypeVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}
