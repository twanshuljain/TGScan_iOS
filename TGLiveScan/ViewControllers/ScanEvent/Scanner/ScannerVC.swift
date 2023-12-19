//
//  ScannerVC.swift
//  TicketGateway
//
//  Created by Apple on 20/06/23.
import UIKit
import AVFoundation
import SDWebImage
import Network

class ScannerVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var qrScannerView: UIView!
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
    @IBOutlet weak var btnOffline: UIButton!
    @IBOutlet weak var btnOfflineHelp: UIButton!
    @IBOutlet weak var lblSunburnReload: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnTourch: UIButton!
    @IBOutlet weak var btn1X: UIButton!
    @IBOutlet weak var btnEndScan: UIButton!
    @IBOutlet weak var lblAccepted: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblRejected: UILabel!
    @IBOutlet weak var imgProfileImage: UIImageView!
    @IBOutlet weak var btnScanAgain: UIButton!
    @IBOutlet weak var imgScanStatus: UIImageView!
    @IBOutlet weak var imgScanStatusBGColor: UIView!
    @IBOutlet weak var lblScanStatusMessage: UILabel!
    @IBOutlet weak var lblQrid: UILabel!
    @IBOutlet weak var btnBack: CustomButtonGradiant!
    @IBOutlet weak var viewInternetAvailivbility: UIView!
    // MARK: - Variables
    let viewModel = ScannerViewModel()
    let monitor = NWPathMonitor()
    var currentZoomFactor: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setFont()
        dataSetToUserModel()
        setUIAndGetScanDetail()
        setUpNetwork()
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            // Reset the UI and Scanner
            self.viewModel.scannerEnable = 1
            self.viewModel.isProcessingQRCode = false
            self.getCameraPreview()
        }
        self.hideScanStatusUI()
        getScanDetail()
    }
}
extension ScannerVC {
    func dataSetToUserModel() {
        let userDataModel = UserDefaultManager.share.getModelDataFromUserDefults(userData: GetScanEventResponse.self, key: .userAuthData)
        viewModel.updateTicketModel.eventId = Int(userDataModel?.info?.masterId ?? "") ?? 0
        viewModel.updateTicketModel.eventName = userDataModel?.info?.eventName ?? ""
        viewModel.updateTicketModel.date = userDataModel?.info?.showdate ?? ""
        viewModel.scanBarCodeModel.eventId = viewModel.updateTicketModel.eventId
        viewModel.scanBarCodeModel.operatorName = userDataModel?.userName ?? ""
    }
    func getCameraPreview(){
        viewModel.captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("error: ", error)
            return
        }
        if viewModel.captureSession.canAddInput(videoInput){
            viewModel.captureSession.addInput(videoInput)
        } else {
            self.imgScanStatus.isHidden = false
            self.imgScanStatus.image = UIImage(named: Wrong)
            showAlertController(message: SCANNING_DOES_NOT_SUPPORT)
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if viewModel.captureSession.canAddOutput(metadataOutput) {
            viewModel.captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            self.imgScanStatus.isHidden = false
            self.imgScanStatus.image = UIImage(named: Wrong)
            showAlertController(message: SCANNING_DOES_NOT_SUPPORT)
            return
        }
        viewModel.previewLayer = AVCaptureVideoPreviewLayer(session: viewModel.captureSession)
        viewModel.previewLayer.frame = qrScannerView.layer.bounds
        viewModel.previewLayer.videoGravity = .resizeAspectFill
        qrScannerView.layer.addSublayer(viewModel.previewLayer)
        self.viewModel.captureSession.startRunning()
    }
    func setZoomFactor(_ factor: CGFloat) {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            try videoCaptureDevice.lockForConfiguration()
            defer { videoCaptureDevice.unlockForConfiguration() }
            
//            let maxZoomFactor = videoCaptureDevice.activeFormat.videoMaxZoomFactor
//            let newZoomFactor = min(maxZoomFactor, max(1.0, currentZoomFactor * factor))
            
            videoCaptureDevice.videoZoomFactor = factor
            currentZoomFactor = factor
        } catch {
            print("Error adjusting zoom factor: \(error.localizedDescription)")
        }
    }

    func setFont() {
        lblQrid.text = ""
        lblScanStatusMessage.text = ""
        lblScan.text = SCAN
        let arrTicketTypes = UserDefaultManager.share.getSelectedTicketTypes()
        let selectedData = arrTicketTypes.filter({$0.isSelected == true })
        lbl3Tix.text = "\(selectedData.count) Tix"
        imgScanStatus.isHidden = true
        imgScanStatusBGColor.isHidden = true
        self.lblQrid.textColor = UIColor.setColor(colorType: .tgBlack)
        self.lblScanStatusMessage.textColor = UIColor.setColor(colorType: .tgBlack)
        lblScan.font = UIFont.setFont(fontType: .medium, fontSize: .twelve)
        let gradient = getGradientLayer(bounds: view.bounds)
        lblScan.textColor = gradientColor(bounds: view.bounds, gradientLayer: gradient)
        self.imgScan.image = UIImage(named: SCAN_SELECTED_ICON)
        self.lblFindRfid.font = UIFont.setFont(fontType: .medium, fontSize: .twelve)
        self.lblFindRfid.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.lblFindRfid.text = FIND_RFID
        self.imgFindRfid.image = UIImage(named: FIND_UNSELECT_ICON)
        self.lblSearch.text = SEARCH
        self.lblSearch.font = UIFont.setFont(fontType: .medium, fontSize: .twelve)
        self.lblSearch.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.imgSearch.image = UIImage(named: SEARCH_UNSELECT_ICON)
        self.lbl3Tix.font = UIFont.setFont(fontType: .regular, fontSize: .twelve)
        self.lbl3Tix.textColor = UIColor.setColor(colorType: .titleColourDarkBlue)
        self.lblSunburnReload.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.lblSunburnReload.textColor = UIColor.setColor(colorType: .titleColourDarkBlue)
        self.lblDate.font = UIFont.setFont(fontType: .regular, fontSize: .twelve)
        self.lblDate.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.btn1X.titleLabel?.font = UIFont.setFont(fontType: .regular, fontSize: .ten)
        self.btn1X.titleLabel?.textColor = UIColor.setColor(colorType: .tgBlue)
        self.btnEndScan.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.btnEndScan.titleLabel?.textColor = UIColor.setColor(colorType: .tgRed)
        self.btnScanAgain.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.btnScanAgain.titleLabel?.textColor = UIColor.setColor(colorType: .tgGrey)
        self.lblAccepted.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.lblAccepted.textColor = UIColor.setColor(colorType: .tgGreen)
        self.lblTotal.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.lblTotal.textColor = UIColor.setColor(colorType: .titleColourDarkBlue)
        self.lblRejected.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.lblRejected.textColor = UIColor.setColor(colorType: .tgRed)
    }
    func setUpNetwork() {
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        checkInternet()
    }
    func checkInternet() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.changeInternetDotColor(colorType: UIColor.setColor(colorType: .tgGreen))
            } else {
                self.changeInternetDotColor(colorType: UIColor.setColor(colorType: .tgRed))
            }
        }
    }
    func changeInternetDotColor(colorType: UIColor) {
        DispatchQueue.main.async {
            self.viewInternetAvailivbility.backgroundColor = colorType
        }
    }
}
// MARK: - Instance Method
extension ScannerVC {
    func setUI() {
        [self.btnSearch, self.btnScan, self.btnFindRfid, self.btnBack, self.btn1X, self.btnTourch, self.btnEndScan, self.btnScanAgain, self.btnOffline, self.btnOfflineHelp].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        }
    }
    func dataSetAfterAPICall() {
        let detailData = viewModel.getScanDetailData
        dataSet() // Data set to labels
        // Store response in local storage
        viewModel.offlineScanLocalModel.acceptedCount = Int(detailData?.acceptedDevice ?? "0") ?? 0
        viewModel.offlineScanLocalModel.rejectedCount = Int(detailData?.rejectedDevice ?? "0") ?? 0
        viewModel.offlineScanLocalModel.totalCount = Int(detailData?.accepted ?? "0") ?? 0
        UserDefaultManager.share.storeModelToUserDefault(userData: viewModel.offlineScanLocalModel, key: .scanOfflineData)
        print("after save data in userdefault at scannerVC:-", UserDefaultManager.share.getModelDataFromUserDefults(userData: OfflineScanLocalModel.self, key: .scanOfflineData) as Any)
    }
    func dataSet() {
        lblAccepted.text = "Accepted : \(viewModel.getScanDetailData?.acceptedDevice ?? "0")"
        lblRejected.text = "Rejected : \(viewModel.getScanDetailData?.rejectedDevice ?? "0")"
        lblTotal.text = "Total : \(viewModel.getScanDetailData?.accepted ?? "0")"
    }
    @objc func buttonPressed(sender: UIButton) {
        switch sender {
        case btnScan:
            self.btnScanAction()
        case btnFindRfid:
            self.btnFindRfidAction()
        case btnSearch:
            self.btnSearchAction()
        case btnBack:
            self.btnBackAction()
        case btn1X:
            self.btn1XAction()
        case btnTourch:
            self.btnTourchAction()
        case btnEndScan:
            self.commanPopup(title: END_SCAN, desc: WANT_TO_SCAN_EVENT)
        case btnScanAgain:
            self.btnScanAgainAction()
        case btnOffline:
            self.btnOfflineAction()
        case btnOfflineHelp:
            self.btnOfflineHelpAction()
        default:
            break
        }
    }
    func btnScanAction() {
    }
    func hideScanStatusUI() {
        imgScanStatus.isHidden = true
        lblQrid.isHidden = true
        lblScanStatusMessage.isHidden = true
        imgScanStatusBGColor.isHidden = true
    }
    func btnScanAgainAction() {
        self.hideScanStatusUI()
        self.viewModel.isProcessingQRCode = false
        print("viewModel.scannerEnable", self.viewModel.scannerEnable)
        if self.viewModel.scannerEnable == 0 {
            self.getCameraPreview()
            print("Get innn")
            // Disable scanner after once tap on scan again button
            self.viewModel.scannerEnable = 1
        }
    }
    func btnFindRfidAction() {
        if let findRFIDVc = createView(storyboard: .main, storyboardID: .FindRFIDVC) as? FindRFIDVC {
            findRFIDVc.viewModel.updateTicketModel = viewModel.updateTicketModel
            self.navigationController?.pushViewController(findRFIDVc, animated: false)
        }
    }
    func btnSearchAction() {
        if let searchVc = createView(storyboard: .main, storyboardID: .SearchVC) as? SearchVC {
            searchVc.viewModel.updateTicketModel = viewModel.updateTicketModel
            self.navigationController?.pushViewController(searchVc, animated: false)
        }
    }
    func btnBackAction() {
        if let selectTicketTypeVC = self.storyboard?.instantiateViewController(withIdentifier:  "SelectTicketTypeVC") as? SelectTicketTypeVC {
            selectTicketTypeVC.viewModel.isFromScannerVC = true
            self.navigationController?.pushViewController(selectTicketTypeVC, animated: false)
        }
    }
    func btnOfflineAction() {
        offlineFetchBarCode()
    }
    func btnOfflineHelpAction() {
        commanPopup(isForOffline: true, title: OFFLINE_SCAN, desc: OFFLINE_SCAN_DESC)
    }
    func btn1XAction() {
        setZoomFactor(viewModel.is2xZoom ? 2 : 1)
        btn1X.setTitle(viewModel.is2xZoom ? "1x" : "2x", for: .normal)
        viewModel.is2xZoom.toggle()
    }
    func btnTourchAction() {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if (device?.hasTorch) != nil {
            do {
                try device?.lockForConfiguration()
                if device?.torchMode == AVCaptureDevice.TorchMode.on {
                    device?.torchMode = AVCaptureDevice.TorchMode.off
                    btnTourch.setImage(UIImage(named: "tourch_ip"), for: .normal)
                } else {
                    do {
                        try device?.setTorchModeOn(level: 1.0)
                        btnTourch.setImage(UIImage(named: "TorchOn"), for: .normal)
                    } catch {
                        print(error)
                    }
                }
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    func commanPopup(isForOffline: Bool = false, title: String, desc: String) {
        let popUpVc = self.createView(storyboard: .main, storyboardID: .EndScanPoPUpVC) as! EndScanPoPUpVC
        popUpVc.delegate = self
        popUpVc.strMsgForTitle = title
        popUpVc.strMsgForDescription = desc
        if isForOffline {
            popUpVc.isStackViewHidden = true
            popUpVc.isViewForOkayButtonHidden = false
        } else {
            popUpVc.isStackViewHidden = false
            popUpVc.isViewForOkayButtonHidden = true
        }
        popUpVc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(popUpVc, animated: true)
    }
    func getScanDetail() {
        if Reachability.isConnectedToNetwork() { // check internet connectivity
            self.view.showLoading(centreToView: self.view)
            viewModel.getScanDetail(
                complition: { isTrue, showMessage in
                    if isTrue {
                        DispatchQueue.main.async {
                            self.view.stopLoading()
                            self.dataSetAfterAPICall()
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
                // Here user is offline, so get data from DB and distribute to UI.
                let localStoredData = UserDefaultManager.share.getModelDataFromUserDefults(
                    userData: OfflineScanLocalModel.self, key: .scanOfflineData
                )
                self.viewModel.getScanDetailData = GetScanDetailData(
                    acceptedDevice: "\(localStoredData?.acceptedCount ?? 0)",
                    rejectedDevice: "\(localStoredData?.rejectedCount ?? 0)",
                    accepted: "\(localStoredData?.totalCount ?? 0)"
                )
                self.dataSet()
            }
        }
    }
    func scanBarCode() {
        var success = false
        var msg = ""
        if Reachability.isConnectedToNetwork() { // check internet connectivity
            viewModel.dispatchGroup.enter()
            self.view.showLoading(centreToView: self.view)
            viewModel.scanBarCodeApi(
                complition: { isTrue, showMessage in
                    if isTrue {
                        success = true
                        msg = showMessage
                        self.viewModel.dispatchGroup.leave()
                        DispatchQueue.main.async {
                            self.view.stopLoading()
                        }
                    } else {
                        success = false
                        msg = showMessage
                        self.viewModel.dispatchGroup.leave()
                        DispatchQueue.main.async {
                            self.view.stopLoading()
                            self.showToast(message: showMessage)
                        }
                    }
                }
            )
            self.viewModel.dispatchGroup.notify(queue: .main) {
                self.setUIAfterScanTicket(isSuccess: success, message: msg)
            }
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
                    self.setUIAfterScanTicket(
                        isSuccess: true,
                        message: "This ticket is valid for this event."
                    )
                    self.updateLocalCounts(isTotal: true, isAccepted: true, isRejected: false)
                } else {
                    // If user already gets entry, increase rejection count, else set status yes ("Y")
                    let data = DatabaseHelper.shareInstance.getEntry(
                        barCode: self.viewModel.scanBarCodeModel.barcode,
                        completion: { isAccepted in
                            if isAccepted {
                                self.setUIAfterScanTicket(
                                    isSuccess: true,
                                    message: "This Ticket scanned successfully."
                                )
                                self.updateLocalCounts(isTotal: true, isAccepted: true, isRejected: false)
                            } else {
                                self.setUIAfterScanTicket(
                                    isSuccess: false,
                                    message: "This ticket is already scanned."
                                )
                                self.updateLocalCounts(isTotal: true, isAccepted: false, isRejected: true)
                            }
                        }
                    )
                    print("data", data as Any)
                }
            }
        }
    }
    func offlineFetchBarCode() {
        if Reachability.isConnectedToNetwork() { // Check internet connection
            self.view.showLoading(centreToView: self.view)
            viewModel.offlineFetchBarCode (
                complition: { isTrue, showMessage in
                    if isTrue {
                        print("Success")
                        DispatchQueue.main.async {
                            self.view.stopLoading()
                            self.commanPopup(isForOffline: true, title: OFFLINE_SCAN, desc: showMessage)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.view.stopLoading()
                            self.commanPopup(isForOffline: true, title: OFFLINE_SCAN, desc: OFFLINE_ERROR)
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
    func updateLocalCounts(isTotal: Bool, isAccepted: Bool, isRejected: Bool) {
        var localStoredData = UserDefaultManager.share.getModelDataFromUserDefults(
            userData: OfflineScanLocalModel.self, key: .scanOfflineData
        )
        localStoredData?.totalCount += isTotal ? 1 : 0
        localStoredData?.acceptedCount += isAccepted ? 1 : 0
        localStoredData?.rejectedCount += isRejected ? 1 : 0
        self.viewModel.getScanDetailData = GetScanDetailData(
            acceptedDevice: "\(localStoredData?.acceptedCount ?? 0)",
            rejectedDevice: "\(localStoredData?.rejectedCount ?? 0)",
            accepted: "\(localStoredData?.totalCount ?? 0)"
        )
        self.dataSet()
        print("localStoredData", localStoredData as Any)
        UserDefaultManager.share.storeModelToUserDefault(userData: localStoredData, key: .scanOfflineData)
    }
    func setUIAfterScanTicket(isSuccess: Bool, message: String) {
        imgScanStatus.isHidden = false
        lblQrid.isHidden = false
        lblScanStatusMessage.isHidden = false
        imgScanStatus.image = UIImage(named: isSuccess ? Right : Wrong)
        imgScanStatusBGColor.isHidden = false
        imgScanStatusBGColor.backgroundColor = UIColor.setColor(colorType: isSuccess ? .tgGreen : .tgRed)
        lblQrid.text = viewModel.scanBarCodeModel.barcode
        lblScanStatusMessage.text = message
        // Enable scanner
        self.viewModel.scannerEnable = 0
        // Get Updated Data after send QRid
        getScanDetail()
    }
    func setUIAndGetScanDetail() {
        viewModel.scanBarCodeModel.operatorName = viewModel.updateTicketModel.userName
        viewModel.scanBarCodeModel.eventId = viewModel.updateTicketModel.eventId
        if let url = (APIHandler.shared.s3URL + viewModel.scanTicketDetails.imageUrl).getCleanedURL() {
            self.imgProfileImage.sd_setImage(with: url, placeholderImage: UIImage(named: "Profile_ip"), options: SDWebImageOptions.continueInBackground)
        } else {
            self.imgProfileImage.image = UIImage(named: "Profile_ip")
        }
        // Set Data to UI Components
        self.lblSunburnReload.text = viewModel.updateTicketModel.eventName
        self.lblDate.text = viewModel.updateTicketModel.date
    }
}
// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first, !self.viewModel.isProcessingQRCode {
                self.viewModel.isProcessingQRCode = true
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return
                }
                self.viewModel.captureSession.stopRunning() // stop scanning after receiving metadata output
                guard let codeString = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.receivedCodeForQR(qrcode: codeString)
            }
    }
    func receivedCodeForQR(qrcode: String) {
        print("qrcode", qrcode)
        viewModel.scanBarCodeModel.barcode = qrcode
        Thread.sleep(forTimeInterval: 1)
        self.scanBarCode()
    }
}
// MARK: - AlertAction
extension ScannerVC: AlertAction {
    func alertYesaction() {
        if let view = createView(storyboard: .main, storyboardID: .ScanSummaryVC) as? ScanSummaryVC {
            view.viewModel.updateTicketModel = viewModel.updateTicketModel
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}
