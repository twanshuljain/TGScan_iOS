//
//  ScanEventVC.swift
//  TicketGateway
//
//  Created by Apple on 16/06/23.
//

import UIKit
class ScanEventVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var lblScanTicket: UILabel!
    @IBOutlet weak var lblEnterDetails: UILabel!
    @IBOutlet weak var lblYourName: UILabel!
    @IBOutlet weak var txtYourName: UITextField!
    @IBOutlet weak var lblEnterPin: UILabel!
    @IBOutlet weak var txtEnterPin: UITextField!
    @IBOutlet weak var btnContinue: CustomButtonGradiant!
    @IBOutlet weak var lblForMoreInfo: UILabel!
    @IBOutlet weak var btnHere: UIButton!
    @IBOutlet weak var btnDissMiss: UIButton!
    @IBOutlet weak var btnSecurePassword: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var backGroundView: UIView!
    // MARK: - Variable
    let viewModel = ScanEventViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFont()
        self.setUI()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 3
        tapGestureRecognizer.delegate = self
        imgLogo.addGestureRecognizer(tapGestureRecognizer)
    }
}
// MARK: - setFont
extension ScanEventVC {
    func setFont() {
        self.lblScanTicket.font = UIFont.setFont(fontType: .bold, fontSize: .twentyFour)
        self.lblScanTicket.textColor = UIColor.setColor(colorType: .titleColourDarkBlue)
        self.lblEnterDetails.font = UIFont.setFont(fontType: .regular, fontSize: .fourteen)
        self.lblEnterDetails.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.lblYourName.font = UIFont.setFont(fontType: .regular, fontSize: .twelve)
        self.lblYourName.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.txtYourName.font = UIFont.setFont(fontType: .regular, fontSize: .sixteen)
        self.txtYourName.textColor = UIColor.setColor(colorType: .titleColourDarkBlue)
        self.lblEnterPin.font = UIFont.setFont(fontType: .regular, fontSize: .twelve)
        self.lblEnterPin.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.txtEnterPin.font = UIFont.setFont(fontType: .regular, fontSize: .sixteen)
        self.txtEnterPin.textColor = UIColor.setColor(colorType: .titleColourDarkBlue)
        self.btnContinue.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.btnContinue.titleLabel?.textColor = UIColor.setColor(colorType: .titleColourDarkBlue)
        self.btnContinue.addRightIcon(image: UIImage(named: RIGHT_ARROW_ICON))
        self.btnHere.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.btnHere.titleLabel?.textColor = UIColor.setColor(colorType: .tgBlue)
        self.lblForMoreInfo.font = UIFont.setFont(fontType: .regular, fontSize: .fourteen)
        self.lblForMoreInfo.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.backGroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    @objc func didTapImageView(_ sender: UITapGestureRecognizer) {
        print("did tap image ")
        addAlert()
    }
}
// MARK: - Instance Method
extension ScanEventVC {
    func setUI() {
        [self.btnContinue, self.btnHere, self.btnDissMiss, self.btnSecurePassword].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        }
    }
    @objc func buttonPressed(sender: UIButton) {
        switch sender {
        case btnContinue:
            self.btnContinueAction()
        case btnHere:
            self.btnHereAction()
        case btnDissMiss:
            self.btnDissmissAction()
        case btnSecurePassword:
            self.btnSecurePasswordAction()
        default:
            break
        }
    }
    func btnContinueAction() {
        viewModel.loginScanModel.username = txtYourName.text?.trimmingCharacters(in: .whitespaces) ?? "-"
        viewModel.loginScanModel.pin = txtEnterPin.text?.trimmingCharacters(in: .whitespaces) ?? "-"
        if viewModel.loginScanModel.username.isEmpty {
            self.showToast(message: Name_Not_Nil)
            return
        } else if viewModel.loginScanModel.pin.isEmpty {
            self.showToast(message: Pin_Not_Nil)
            return
        }
        scanTicketLogin()
    }
    func btnHereAction() {
        if let url = URL(string: "https://www.ticketgateway.com/pages/mobileapp/") {
            UIApplication.shared.open(url)
        }
    }
    func btnDissmissAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func btnSecurePasswordAction() {
        if self.txtEnterPin.isSecureTextEntry == false {
            self.btnSecurePassword.setImage(UIImage(named: EYE_CLOSE), for: .normal)
            self.txtEnterPin.isSecureTextEntry = true
        } else {
            self.btnSecurePassword.setImage(UIImage(named: EYE_OPEN), for: .normal)
            self.txtEnterPin.isSecureTextEntry = false
        }
    }
    func addAlert() {
        let alert = UIAlertController(title: "Setup your base url to set web service environment fort TG live scan", message: "Enter base url:", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter base url:"
            textField.text = "https://api.tg-dev2.com/"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField?.text))")
            if let txt = textField?.text {
                APIHandler.shared.baseURL = txt
            }
        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }

    func scanTicketLogin() {
        if Reachability.isConnectedToNetwork() { // check internet connectivity
            self.view.showLoading(centreToView: self.view)
            viewModel.scanTicketApi(
                scanTicketModel: viewModel.loginScanModel,
                complition: { isTrue, showMessage in
                    if isTrue {
                        DispatchQueue.main.async {
                            self.view.stopLoading()
                            let selectTicketTypeVC = self.createView(storyboard: .main, storyboardID: .SelectTicketTypeVC) as? SelectTicketTypeVC
                            selectTicketTypeVC?.viewModel.updateTicketModel.eventId =
                            Int(self.viewModel.getScanEventResponse?.info?.masterId ?? "0") ?? 0
                            selectTicketTypeVC?.viewModel.updateTicketModel.eventName =
                            self.viewModel.getScanEventResponse?.info?.eventName ?? ""
                            selectTicketTypeVC?.viewModel.updateTicketModel.date =
                            self.viewModel.getScanEventResponse?.info?.showdate ?? ""
                            selectTicketTypeVC?.viewModel.updateTicketModel.userName =
                            self.viewModel.loginScanModel.username
                            self.navigationController?.pushViewController(selectTicketTypeVC ?? UIViewController(), animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.view.stopLoading()
                            self.showToast(message: showMessage)
                        }
                    }
                }
            )
        } else {
            DispatchQueue.main.async {
                self.view.stopLoading()
                self.showToast(message: ValidationConstantStrings.networkLost)
            }
        }
    }
}
extension ScanEventVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
