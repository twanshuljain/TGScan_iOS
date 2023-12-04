//
//  SelectTicketTypeVC.swift
//  TicketGateway
//
//  Created by Apple on 16/06/23.

import UIKit
class SelectTicketTypeVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tblTicketTypeTablView: UITableView!
    @IBOutlet weak var vwNavigationView: NavigationBarView!
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var btnDone: CustomButtonGradiant!
    // MARK: - Variable
    let viewModel = SelectTicketTypeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSetToUserModel()
        self.setNavigationview()
        self.setTableView()
        self.setFont()
        self.setUI()
        getTicketTypeList()
    }
}

// MARK: -
extension SelectTicketTypeVC {
    func dataSetToUserModel() {
        let userDataModel = UserDefaultManager.share.getModelDataFromUserDefults(userData: GetScanEventResponse.self, key: .userAuthData)
        viewModel.updateTicketModel.eventId = Int(userDataModel?.info?.masterId ?? "") ?? 0
        viewModel.updateTicketModel.eventName = userDataModel?.info?.eventName ?? ""
        viewModel.updateTicketModel.date = userDataModel?.info?.showdate ?? ""
    }
    func setNavigationview() {
        vwNavigationView.delegateBarAction = self
        vwNavigationView.imgBack.isHidden = !viewModel.isFromScannerVC
        vwNavigationView.btnBack.isHidden = !viewModel.isFromScannerVC
        self.vwNavigationView.btnRight.isHidden = false
        self.vwNavigationView.btnRight.setImage(UIImage(named: "Logout"), for: .normal)
        vwNavigationView.lblTitle.text = SELECT_TICKET_TYPE
        vwNavigationView.lblTitle.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        vwNavigationView.lblTitle.textColor = UIColor.setColor(colorType: .titleColourDarkBlue)
        vwNavigationView.vwBorder.isHidden = false
    }
    func setTableView() {
        tblTicketTypeTablView.delegate = self
        tblTicketTypeTablView.dataSource = self
        self.tblTicketTypeTablView.register(UINib(nibName: "OfflineModeTableViewCell", bundle: nil), forCellReuseIdentifier: "OfflineModeTableViewCell")
        tblTicketTypeTablView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func setFont() {
        btnSelectAll.titleLabel?.font = UIFont.setFont(fontType: .semiBold, fontSize: .sixteen)
        btnSelectAll.titleLabel?.textColor = UIColor.setColor(colorType: .tgBlue)
        btnDone.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        btnDone.titleLabel?.textColor = UIColor.setColor(colorType: .btnDarkBlue)
    }
    func getTicketTypeList() {
        if Reachability.isConnectedToNetwork() { // check internet connectivity
            self.view.showLoading(centreToView: self.view)
            viewModel.getTicketTypeList(
                complition: { isTrue, showMessage in
                    if isTrue {
                        print("Success")
                        DispatchQueue.main.async {
                            self.view.stopLoading()
                            self.tblTicketTypeTablView.reloadData()
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
    func updateTickets() {
        if Reachability.isConnectedToNetwork() { // check internet connectivity
            self.view.showLoading(centreToView: self.view)
            viewModel.updateTickets(
                complition: { isTrue, showMessage in
                    if isTrue {
                        print("Success")
                        DispatchQueue.main.async {
                            self.view.stopLoading()
                            if let scannerVC = self.createView(storyboard: .main, storyboardID: .ScannerVC) as? ScannerVC {
                                scannerVC.viewModel.updateTicketModel.eventId = self.viewModel.updateTicketModel.eventId
                                scannerVC.viewModel.updateTicketModel.eventName = self.viewModel.updateTicketModel.eventName
                                scannerVC.viewModel.updateTicketModel.date = self.viewModel.updateTicketModel.date
                                scannerVC.viewModel.updateTicketModel.userName = self.viewModel.updateTicketModel.userName
                                self.navigationController?.pushViewController(scannerVC, animated: false)
                                self.navigationController?.viewControllers = [scannerVC]
                            }
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
    @objc func actionSwitch(_ sender: UISwitch) {
        viewModel.arrTicketTypes[sender.tag].isSelected = !(viewModel.arrTicketTypes[sender.tag].isSelected ?? false)
        tblTicketTypeTablView.reloadData()
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension SelectTicketTypeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return viewModel.arrTicketTypes.count
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "OfflineModeTableViewCell", for: indexPath) as! OfflineModeTableViewCell
//            cell.lblOffline.text = "Offline Mode"
//            cell.uiSwitch.addTarget(self, action: #selector(self.offlineSwitchAction(_:)), for: .touchUpInside)
//            cell.lblOffline.textColor = UIColor.setColor(colorType: .tgRed)
//            cell.lblOffline.font = UIFont.setFont(fontType: .regular, fontSize: .fourteen)
//            cell.uiSwitch.setOn(viewModel.isOfflineSwitchEnable, animated: false)
//            cell.selectionStyle = .none
//            return cell
//        } else
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let button = UIButton(type: .system)
            button.setTitle("Select All", for: .normal)
            button.titleLabel?.font = UIFont.setFont(fontType: .semiBold, fontSize: .sixteen)
            button.titleLabel?.textColor = UIColor.setColor(colorType: .tgBlue)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            cell.contentView.addSubview(button)
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16).isActive = true
            button.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTicketTypeTableviewCell", for: indexPath) as! SelectTicketTypeTableviewCell
            let data = viewModel.arrTicketTypes[indexPath.row]
            cell.lblTicketType.text = data.ticketName
            cell.swTicketTypeSwitch.setOn(data.isSelected ?? false, animated: false)
            cell.swTicketTypeSwitch.tag = indexPath.row
            cell.swTicketTypeSwitch.addTarget(self, action: #selector(self.actionSwitch(_:)), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
// MARK: -
extension SelectTicketTypeVC {
    func setUI() {
        [self.btnDone, self.btnSelectAll].forEach {
            $0?.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        }
    }
    @objc func buttonTapped() {
        btnSelectAllAction()
    }

    @objc func buttonPressed(sender: UIButton) {
        switch sender {
        case btnDone:
            self.btnDoneAction()
        case btnSelectAll:
            self.btnSelectAllAction()
        default:
            break
        }
    }
    func btnDoneAction() {
        let selectedData = viewModel.arrTicketTypes.filter({$0.isSelected == true })
        guard !selectedData.isEmpty else {
            showAlertController(title: "Alert", message: SelectTicketMessage)
            return
        }
        viewModel.updateTicketModel.ticketIds = selectedData.map {
            String($0.id.trimmingCharacters(in: .whitespaces))
        }.joined(separator: ",")
        print("selectedTicketIds", viewModel.updateTicketModel.ticketIds)
        // Save selected ticket types in User Defaults
        UserDefaultManager.share.setSelectedTicketTypes(selectedTickets: viewModel.arrTicketTypes)
        updateTickets()
    }
    func btnSelectAllAction() {
        viewModel.arrTicketTypes.indices.forEach { self.viewModel.arrTicketTypes[$0].isSelected = true }
        tblTicketTypeTablView.reloadData()
    }
    func showLogoutAlert() {
        let alert = UIAlertController.init(title: "Logout", message: "Do you want to logout?", preferredStyle: .alert)
        let btnCancel = UIAlertAction.init(title: "Cancel", style: .default) { _ in
        }
        let btnYes = UIAlertAction.init(title: "Yes", style: .destructive) { _ in
            UserDefaultManager.share.removeUserDefualtsModels(key: .userAuthData) // Clear session when user logged out.
            print("after delete userDefault at ticket type", UserDefaultManager.share.getModelDataFromUserDefults(userData: GetScanEventResponse.self, key: .userAuthData) as Any)
            // Remove selected Ticket Types on Logout
            UserDefaultManager.share.removeSelectedTicketTypes()
            let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "ScanEventNav") as? UINavigationController
            (UIApplication.shared.windows.first)?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(btnCancel)
        alert.addAction(btnYes)
        self.present(alert, animated: true, completion: nil)
    }
}
// MARK: - NavigationBarViewDelegate
extension SelectTicketTypeVC: NavigationBarViewDelegate {
    func navigationBackAction() {
        print("back clicked")
        self.navigationController?.popViewController(animated: false)
    }
    func navigationRightButtonAction() {
        showLogoutAlert()
    }
}
