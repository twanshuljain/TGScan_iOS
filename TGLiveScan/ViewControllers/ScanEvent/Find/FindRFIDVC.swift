//
//  FindRFIDVC.swift
//  TicketGateway
//
//  Created by Apple on 22/06/23.

import UIKit
import SDWebImage
import CoreNFC

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
        setFont()
        setUI()
        startNFCReading()
        dataSetToUserModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.isConnected = false
        let localStoredData = UserDefaultManager.share.getModelDataFromUserDefults(
            userData: OfflineScanLocalModel.self, key: .scanOfflineData
        )
        dataSetToUI(localStoredData: localStoredData ?? OfflineScanLocalModel())
    }
}
// MARK: -
extension FindRFIDVC {
    func setImages() {
        if viewModel.isConnected {
            connectedStackView.isHidden = false
            lblKeepCloserYourDevice.isHidden = true
            imgConnect.isHidden = true
        } else {
            connectedStackView.isHidden = true
            lblKeepCloserYourDevice.isHidden = false
            imgConnect.isHidden = false
        }
    }
    func setFont() {
        setImages()
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
    func dataSetToUserModel() {
        let userDataModel = UserDefaultManager.share.getModelDataFromUserDefults(userData: GetScanEventResponse.self, key: .userAuthData)
        viewModel.scanBarCodeModel.eventId = Int(userDataModel?.info?.masterId ?? "0") ?? 0
        viewModel.scanBarCodeModel.operatorName = userDataModel?.userName ?? ""
    }
    func dataSetToUI(localStoredData: OfflineScanLocalModel) {
        lblAccepted.text = "Accepted : \(localStoredData.acceptedCount)"
        lblRejected.text = "Rejected : \(localStoredData.rejectedCount)"
        lblTotal.text = "Total : \(localStoredData.totalCount)"
    }
}
// MARK: - Instance Method
extension FindRFIDVC {
    func setUI() {
        [self.btnSearch, self.btnScan, self.btnFindRfid, self.btnTicket, btnEndScan].forEach {
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
        case btnEndScan:
            self.btnEndScanAction()
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
    func btnEndScanAction() {
        let popUpVc = self.createView(storyboard: .main, storyboardID: .EndScanPoPUpVC) as! EndScanPoPUpVC
        popUpVc.delegate = self
        popUpVc.isStackViewHidden = false
        popUpVc.isViewForOkayButtonHidden = true
        popUpVc.strMsgForTitle = END_SCAN
        popUpVc.strMsgForDescription = WANT_TO_SCAN_EVENT
        popUpVc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(popUpVc, animated: true)
    }
    func btnFindRfidAction() {
        // To reset the scanner for NFC tag.
        self.startNFCReading()
        viewModel.isConnected = false
        setImages()
    }
    func btnSearchAction() {
        if let searchVC = createView(storyboard: .main, storyboardID: .SearchVC) as? SearchVC {
            // Send data back to previous screen
            searchVC.viewModel.updateTicketModel = viewModel.updateTicketModel
            self.navigationController?.pushViewController(searchVC, animated: false)
        }
    }
    func btnTicketAction() {
        self.navigationController?.popViewController(animated: false)
    }
    func startNFCReading() {
        DispatchQueue.main.async {
            guard NFCNDEFReaderSession.readingAvailable else {
                let alertController = UIAlertController(
                    title: "Scanning Not Supported",
                    message: "This device doesn't support tag scanning.",
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.viewModel.nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
            self.viewModel.nfcSession?.alertMessage = "Hold your iPhone near the item to learn more about it."
            self.viewModel.nfcSession?.begin()
        }
    }
    // Get entry by the NFC tag bar code
    func scanBarCode() {
        if Reachability.isConnectedToNetwork() { // check internet connectivity
            DispatchQueue.main.async {
                self.view.showLoading(centreToView: self.view)
            }
            viewModel.scanBarCodeApi(
                complition: { isTrue, showMessage in
                    if isTrue {
                        DispatchQueue.main.async {
                            self.viewModel.isConnected = true
                            self.view.stopLoading()
                            self.setImages()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.viewModel.isConnected = false
                            self.setImages()
                            self.view.stopLoading()
                            self.showToast(message: showMessage)
                        }
                    }
                }
            )
        } else {
            DispatchQueue.main.async {
                // Store this barcode in DB if not stored.
                if DatabaseHelper.shareInstance.fetchRecordByBarCode(barCode: self.viewModel.scanBarCodeModel.barcode) == nil {
                    DatabaseHelper.shareInstance.save(
                        offlineScan: GetOfflineFetchBarCodeResponse(
                            barCode: self.viewModel.scanBarCodeModel.barcode,
                            eventId: "\(self.viewModel.scanBarCodeModel.eventId)",
                            ticketId: "0",
                            ticketType: "1",
                            usedStatus: "Y",
                            countForRejection: 0
                        )
                    )
                    // SetUI after save in DB
                    self.viewModel.isConnected = true
                    self.setImages()
                    self.updateLocalCounts(isTotal: true, isAccepted: true, isRejected: false)
                } else {
                    // If user already gets entry, increase rejection count, else set status yes ("Y")
                    let data = DatabaseHelper.shareInstance.getEntry(
                        barCode: self.viewModel.scanBarCodeModel.barcode,
                        completion: { isAccepted in
                            if isAccepted {
                                self.viewModel.isConnected = true
                                self.setImages()
                                self.updateLocalCounts(isTotal: true, isAccepted: true, isRejected: false)
                            } else {
                                self.viewModel.isConnected = false
                                self.setImages()
                                self.updateLocalCounts(isTotal: true, isAccepted: false, isRejected: true)
                                self.showToast(message: "This ticket is already scanned.")
                            }
                        }
                    )
                    print("data", data as Any)
                }
            }
        }
    }
    func updateLocalCounts(isTotal: Bool, isAccepted: Bool, isRejected: Bool) {
        var localStoredData = UserDefaultManager.share.getModelDataFromUserDefults(
            userData: OfflineScanLocalModel.self, key: .scanOfflineData
        )
        localStoredData?.totalCount += isTotal ? 1 : 0
        localStoredData?.acceptedCount += isAccepted ? 1 : 0
        localStoredData?.rejectedCount += isRejected ? 1 : 0
        self.dataSetToUI(localStoredData: localStoredData ?? OfflineScanLocalModel())
        print("localStoredData", localStoredData as Any)
        UserDefaultManager.share.storeModelToUserDefault(userData: localStoredData, key: .scanOfflineData)
        dataSetToUI(localStoredData: localStoredData ?? OfflineScanLocalModel())
    }
}
extension FindRFIDVC: NFCNDEFReaderSessionDelegate {
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print(session)
    }
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        guard let message = messages.first else {
            return
        }
        viewModel.nfcBarCodeId.removeAll()
        for record in message.records {
            print("Payload: \(record.payload)")
            let data = String(data: record.payload,encoding:.utf8)
            if let data = data {
                self.viewModel.nfcBarCodeId.append(data)
            }
        }
        print("NFC barcode:- ", self.viewModel.nfcBarCodeId)
        // Update bar code API (Gets entry)
        if !viewModel.nfcBarCodeId.isEmpty {
            self.viewModel.scanBarCodeModel.barcode = viewModel.nfcBarCodeId.first ?? ""
            scanBarCode()
        }
        // Optionally, you can stop the session after the first read
        session.invalidate()
    }
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("NFC session invalidated with error: \(error.localizedDescription)")
    }
}
extension FindRFIDVC: AlertAction {
    func alertYesaction() {
        if let view = createView(storyboard: .main, storyboardID: .ScanSummaryVC) as? ScanSummaryVC {
            view.viewModel.updateTicketModel = viewModel.updateTicketModel
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}
    
