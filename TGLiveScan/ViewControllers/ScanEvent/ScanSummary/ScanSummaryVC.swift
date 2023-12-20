//
//  ScanSummaryVC.swift
//  TicketGateway
//
//  Created by Apple on 21/06/23.
import UIKit
import Charts
import SDWebImage
class ScanSummaryVC: UIViewController, ChartViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var vwNavigationView: NavigationBarView!
    @IBOutlet weak var lblSunburnReload: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var lblTotalTickets: UILabel!
    @IBOutlet weak var lblTotalTicketValue: UILabel!
    @IBOutlet weak var tblScanAllTableView: UITableView!
    @IBOutlet weak var tblScan: UITableView!
    @IBOutlet weak var scanSummaryView: UIView!
    @IBOutlet weak var btnSendStatusReport: UIButton!
    @IBOutlet weak var btnUpdateLiveOnServer: UIButton!
    @IBOutlet weak var tblViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgProfile: UIImageView!
    // MARK: - Variables
    let viewModel = ScanSummaryViewModel()
     let tblData = ["Tix to scan", "Tix Scanned", "Accepted", "Rejected", "Scanned Hard Tix", "Scanned PDF Tix", "Scanned Comps Tix"]
    override func viewDidLoad() {
        super.viewDidLoad()
        getScanSummary()
        self.setNavigationView()
        self.setFont()
        self.setTableView()
        dataSetToUserModel()
        self.chartView.delegate = self
        self.tblScanAllTableView.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
       // self.tblScan.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
        self.tblViewHeight.constant = self.tblScanAllTableView.contentSize.height
        //self.tblScanViewHt.constant = self.tblScan.contentSize.height
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.tblViewHeight.constant = tblScanAllTableView.contentSize.height
        //self.tblScanViewHt.constant = tblScan.contentSize.height
    }
    @IBAction func actionSendStatusReport(_ sender: UIButton) {
        sendReportToPromoter()
    }
    @IBAction func actionUpdateOnLiveServer(_ sender: UIButton) {
        let data = DatabaseHelper.shareInstance.getAllData() as? [OfflineScan]
        viewModel.arrUpdateOfflineDataOnServerModel = []
        data?.forEach { record in
            viewModel.arrUpdateOfflineDataOnServerModel?.append(
                UpdateOfflineDataOnServerModel(
                    barCode: record.barCode ?? "",
                    countForRejection: Int(record.countForRejection),
                    eventId: record.eventId ?? "",
                    ticketId: record.ticketId,
                    ticketType: record.ticketType,
                    usedStatus: record.usedStatus
                )
            )
        }
        debugPrint("upload on live server", viewModel.arrUpdateOfflineDataOnServerModel)
    }
}
// MARK: -
extension ScanSummaryVC {
    func dataSetToUserModel() {
        let userDataModel = UserDefaultManager.share.getModelDataFromUserDefults(userData: GetScanEventResponse.self, key: .userAuthData)
        viewModel.updateTicketModel.eventId = Int(userDataModel?.info?.masterId ?? "") ?? 0
        viewModel.updateTicketModel.userName = userDataModel?.userName ?? ""
    }
    func setTableView() {
        self.tblScanAllTableView.separatorColor = UIColor.clear
        self.tblScanAllTableView.delegate = self
        self.tblScanAllTableView.dataSource = self
        
        self.tblScan.separatorColor = UIColor.clear
        self.tblScan.delegate = self
        self.tblScan.dataSource = self
        self.tblScan.register(UINib(nibName: "ScanSummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "ScanSummaryTableViewCell")
    }
    
    func setFooterView(){
        // Load the custom footer view from the nib file
        let customFooterNib = UINib(nibName: "ScanSummaryFooterView", bundle: nil)
        if let customFooterView = customFooterNib.instantiate(withOwner: nil, options: nil).first as? ScanSummaryFooterView {
            // Set it as the table view's footer view
            tblScan.tableFooterView = customFooterView
            // You can customize the height of the footer view if needed
            customFooterView.frame = CGRect(x: 0, y: 0, width: tblScan.frame.width, height: 120)
        }
    }
    func showLogoutAlert() {
        let alert = UIAlertController.init(title: LOGOUT_TITLE, message: LOGOUT_MESSAGE, preferredStyle: .alert)
        let btnCancel = UIAlertAction.init(title: "Cancel", style: .default) { _ in
        }
        let btnLogout = UIAlertAction.init(title: "Logout", style: .destructive) { _ in
            // Clear session when user logged out.
            UserDefaultManager.share.removeUserDefualtsModels(key: .userAuthData)
            print("after delete userDefault at ticket type", UserDefaultManager.share.getModelDataFromUserDefults(userData: GetScanEventResponse.self, key: .userAuthData) as Any)
            // Remove selected Ticket Types on Logout
            UserDefaultManager.share.removeSelectedTicketTypes()
            // Clear Database on Logout
            DatabaseHelper.shareInstance.deleteAllData(forEntity: "OfflineScan")
            let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "ScanEventNav") as? UINavigationController
            (UIApplication.shared.windows.first)?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(btnCancel)
        alert.addAction(btnLogout)
        self.present(alert, animated: true, completion: nil)
    }
    func setNavigationView() {
        self.vwNavigationView.delegateBarAction = self
        self.vwNavigationView.btnBack.isHidden = false
        self.vwNavigationView.btnRight.isHidden = false
        self.vwNavigationView.btnRight.setImage(UIImage(named: "Logout"), for: .normal)
        self.vwNavigationView.lblTitle.text = SCAN_SUMMARY
        self.vwNavigationView.lblTitle.font = UIFont.setFont(fontType: .medium, fontSize: .sixteen)
        self.vwNavigationView.lblTitle.textColor = UIColor.setColor(colorType: .titleColourDarkBlue)
        self.vwNavigationView.vwBorder.isHidden = false
        self.scanSummaryView.isHidden = true
    }
    func setChart() {
        var entries = [ChartDataEntry]()
        viewModel.arrOfValueChart.forEach { data in
            print("data", data)
            entries.append(ChartDataEntry(x: Double(data), y: Double(data)))
        }
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.chartColor()
        set.drawValuesEnabled = false
        let data = PieChartData(dataSet: set)
        chartView.data = data
        chartView.holeColor = UIColor.clear
        self.chartView.legend.enabled = false
        chartView.holeRadiusPercent = 0.7
    }
    func setFont() {
        // If user with guest login
        if UserDefaultManager.share.getUserBoolValue(key: .isGuestLogin) {
            btnUpdateLiveOnServer.isHidden = true
        }
        self.lblSunburnReload.font = UIFont.setFont(fontType: .semiBold, fontSize: .sixteen)
        self.lblSunburnReload.textColor = UIColor.setColor(colorType: .tgBlack)
        self.lblDate.font = UIFont.setFont(fontType: .regular, fontSize: .fourteen)
        self.lblDate.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.lblTotalTickets.font = UIFont.setFont(fontType: .regular, fontSize: .fourteen)
        self.lblTotalTickets.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.lblTotalTicketValue.font = UIFont.setFont(fontType: .semiBold, fontSize: .fourteen)
        self.lblTotalTicketValue.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.btnSendStatusReport.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.btnSendStatusReport.titleLabel?.textColor = UIColor.setColor(colorType: .white)
        self.btnUpdateLiveOnServer.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.btnUpdateLiveOnServer.titleLabel?.textColor = UIColor.setColor(colorType: .btnDarkBlue)
    }
    func getScanSummary() {
        if Reachability.isConnectedToNetwork() {
            self.view.showLoading(centreToView: self.view)
            viewModel.getScanSummary(completion: { isTrue, message in
                if isTrue {
                    self.view.stopLoading()
                    self.dataSettingAfterScanOverview()
                    self.setChart()
                    self.tblScanAllTableView.reloadData()
                } else {
                    DispatchQueue.main.async {
                        self.view.stopLoading()
                        self.showToast(message: message)
                    }
                }
            })
        } else {
            DispatchQueue.main.async {
                self.view.stopLoading()
                self.showToast(message: ValidationConstantStrings.networkLost)
            }
        }
    }
    // Send status report to promoter
    func sendReportToPromoter() {
        if Reachability.isConnectedToNetwork() {
            self.view.showLoading(centreToView: self.view)
            viewModel.sendReportToPromoter(completion: { isTrue, message in
                if isTrue {
                    self.view.stopLoading()
                    self.showToast(message: message)
                } else {
                    DispatchQueue.main.async {
                        self.view.stopLoading()
                        self.showToast(message: message)
                    }
                }
            })
        } else {
            DispatchQueue.main.async {
                self.view.stopLoading()
                self.showToast(message: ValidationConstantStrings.networkLost)
            }
        }
    }
    func dataSettingAfterScanOverview() {
        let totalTickets = (viewModel.getScanSummaryResponse?.totalTicketToScan ?? 0) + (viewModel.getScanSummaryResponse?.totalTicketScanned ?? 0)
        lblSunburnReload.text = viewModel.updateTicketModel.eventName
        lblDate.text = viewModel.updateTicketModel.date
        lblTotalTicketValue.text = "\(totalTickets)"
        if let url = (APIHandler.shared.s3URL + (viewModel.getScanOverviewData.eventCoverImage ?? "")).getCleanedURL() {
            self.imgProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "Profile_ip"), options: SDWebImageOptions.continueInBackground)
        } else {
            self.imgProfile.image = UIImage(named: "Profile_ip")
        }
        viewModel.arrOfValueChart = []
        viewModel.arrOfValueChart.append(viewModel.getScanSummaryResponse?.totalTicketToScan ?? 0)
        viewModel.arrOfValueChart.append(viewModel.getScanSummaryResponse?.totalTicketScanned ?? 0)
        viewModel.arrOfValueChart.append(viewModel.getScanSummaryResponse?.accepted ?? 0)
        viewModel.arrOfValueChart.append(viewModel.getScanSummaryResponse?.rejected ?? 0)
        viewModel.arrOfValueChart.append(Int(viewModel.getScanSummaryResponse?.scannedHard ?? "0") ?? 0)
        viewModel.arrOfValueChart.append(viewModel.getScanSummaryResponse?.scannedPDF ?? 0)
        viewModel.arrOfValueChart.append(Int(viewModel.getScanSummaryResponse?.scannedComp ?? "0") ?? 0)
        print("viewModel.arrOfValueChart:-", viewModel.arrOfValueChart)
    }
}

// MARK: - ACTIONS
extension ScanSummaryVC{
    @IBAction func actionSegment(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            print("ALL")
            self.scrollView.isScrollEnabled = true
            self.scanSummaryView.isHidden = true
        case 1:
            print("SCANNED")
            self.viewModel.scanSummaryModel.tab = "SCANNED"
            self.viewModel.updateTicketModel.eventId = self.viewModel.getScanOverviewData.eventId ?? 0
            self.scrollView.isScrollEnabled = true
            self.scanSummaryView.isHidden = false
//            self.getScanSummary()
        case 2:
            print("ACCEPTED")
            self.viewModel.scanSummaryModel.tab = "ACCEPTED"
            self.viewModel.updateTicketModel.eventId = self.viewModel.getScanOverviewData.eventId ?? 0
            self.scrollView.isScrollEnabled = true
            self.scanSummaryView.isHidden = false
//            self.getScanSummary()
        case 3:
            print("Rest")
            self.viewModel.scanSummaryModel.tab = "REJECTED"
            self.viewModel.updateTicketModel.eventId = self.viewModel.getScanOverviewData.eventId ?? 0
            self.scrollView.isScrollEnabled = true
            self.scanSummaryView.isHidden = false
//            self.getScanSummary()
            
        default:
            break
        }
    }
    
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension ScanSummaryVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblScanAllTableView {
            return tblData.count
        }else if tableView == self.tblScan {
            return self.viewModel.getScanSummaryItem.count
        }
        return 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblScanAllTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ScanAllTableViewCell", for: indexPath) as? ScanAllTableViewCell {
                cell.selectionStyle = .none
                let data = tblData[indexPath.row]
                switch data {
                case TicketStatusList.tixToScan.rawValue:
                    cell.lblTitleValue.text = "\(viewModel.getScanSummaryResponse?.totalTicketToScan ?? 0)"
                    cell.vwColorView.backgroundColor = UIColor.hexColor(hex: "#CDC8F9")
                case TicketStatusList.tixScanned.rawValue:
                    cell.lblTitleValue.text = "\(viewModel.getScanSummaryResponse?.totalTicketScanned ?? 0)"
                    cell.vwColorView.backgroundColor = UIColor.hexColor(hex: "#A0CF67")
                case TicketStatusList.accepted.rawValue:
                    cell.lblTitleValue.text = "\(viewModel.getScanSummaryResponse?.accepted ?? 0)"
                    cell.vwColorView.backgroundColor = UIColor.hexColor(hex: "#FB896B")
                case TicketStatusList.rejected.rawValue:
                    cell.lblTitleValue.text = "\(viewModel.getScanSummaryResponse?.rejected ?? 0)"
                    cell.vwColorView.backgroundColor = UIColor.hexColor(hex: "#FFD467")
                case TicketStatusList.scannedHardTix.rawValue:
                    cell.lblTitleValue.text = "\(viewModel.getScanSummaryResponse?.scannedHard ?? "0")"
                    cell.vwColorView.backgroundColor = UIColor.hexColor(hex: "#C6E0FF")
                case TicketStatusList.scannedPdfTix.rawValue:
                    cell.lblTitleValue.text = "\(viewModel.getScanSummaryResponse?.scannedPDF ?? 0)"
                    cell.vwColorView.backgroundColor = UIColor.hexColor(hex: "#FFBDE1")
                case TicketStatusList.scannedCompsTix.rawValue:
                    cell.lblTitleValue.text = "\(viewModel.getScanSummaryResponse?.scannedComp ?? "0")"
                    cell.vwColorView.backgroundColor = UIColor.hexColor(hex: "#FFDDC6")
                default:
                    break
                }
                cell.selectionStyle = .none
                cell.lblSummaryTitle.text = data
                return cell
            }
            return UITableViewCell()
        }else if tableView == self.tblScan {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ScanSummaryTableViewCell", for: indexPath) as? ScanSummaryTableViewCell{
                cell.selectionStyle = .none
                if self.viewModel.getScanSummaryItem.indices.contains(indexPath.row) {
                    cell.setData(data: self.viewModel.getScanSummaryItem[indexPath.row])
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tblScanAllTableView{
            return UITableView.automaticDimension
        }else if tableView == self.tblScan{
            return 60
        }
        return UITableView.automaticDimension
    }
}
// MARK: - NavigationBarViewDelegate
extension ScanSummaryVC: NavigationBarViewDelegate {
    func navigationBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func navigationRightButtonAction() {
        print("logout")
        showLogoutAlert()
    }
}
