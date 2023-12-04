//
// SearchVC.swift
// TicketGateway
//
// Created by Apple on 21/06/23.
import UIKit
import Foundation
class SearchVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tblSearchTableView: UITableView!
    @IBOutlet weak var lblScan: UILabel!
    @IBOutlet weak var imgScan: UIImageView!
    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var lblFindRfid: UILabel!
    @IBOutlet weak var imgFindRfid: UIImageView!
    @IBOutlet weak var btnFindRfid: UIButton!
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblSearchText: UITextField!
    // MARK: - Variables
    let viewModel = SearchViewModel()
    let textField = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setFont()
        self.setTableView()
        self.setTextField()
        self.dataSetToUserModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func dataSetToUserModel() {
        let userDataModel = UserDefaultManager.share.getModelDataFromUserDefults(userData: GetScanEventResponse.self, key: .userAuthData)
        viewModel.updateTicketModel.eventId = Int(userDataModel?.info?.masterId ?? "0") ?? 0
        viewModel.updateTicketModel.userName = userDataModel?.userName ?? ""
        viewModel.scanBarCodeModel.operatorName = userDataModel?.userName ?? ""
        viewModel.scanBarCodeModel.eventId = viewModel.updateTicketModel.eventId
    }
    func setTextField() {
        self.view.addSubview(textField)
        textField.frame = CGRect(origin: .zero, size: .zero)
        let txtSearch = CustomSearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        textField.delegate = self
        lblSearchText.delegate = self
        txtSearch.txtSearch.delegate = self
        txtSearch.locationView.isHidden = true
        txtSearch.btnMenu.isHidden = true
        txtSearch.btnFilter.isHidden = true
        txtSearch.txtSearch.isHidden = false
        txtSearch.txtSearch.becomeFirstResponder()
        textField.inputAccessoryView = txtSearch
        textField.becomeFirstResponder()
        txtSearch.txtSearch.addTarget(self, action: #selector(txtSearchData), for: .allEditingEvents)
        txtSearch.txtSearch.becomeFirstResponder()
    }
    @objc func txtSearchData(_ sender: UITextField) {
        lblSearchText.text = sender.text
        viewModel.isFromSearchTxtField = true
        viewModel.filterData(searchText: sender.text ?? "") { [weak self] in
            if let self {
                self.tblSearchTableView.reloadData()
            }
        }
    }
    
    func getEmailSearchedData(email: String) {
        if Reachability.isConnectedToNetwork() { // check internet connectivity
            self.view.showLoading(centreToView: self.view)
            viewModel.getEmailSearchedData(emailId: email,
                complition: { isTrue, showMessage in
                    if isTrue {
                        print("Success")
                        DispatchQueue.main.async {
                            self.view.stopLoading()
                            self.tblSearchTableView.reloadData()
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
    func updateEmailEntry(selectedBarCode: String) {
        if Reachability.isConnectedToNetwork() { // check internet connectivity
            self.view.showLoading(centreToView: self.view)
            viewModel.getEmailOrders(selectedBarCode: selectedBarCode,
                complition: { isTrue, showMessage in
                    if isTrue {
                        print("Success")
                        DispatchQueue.main.async {
                            // call get email orders api after update the email entry
                            self.getEmailSearchedData(email: self.viewModel.emailId)
                            self.view.stopLoading()
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
    func getBarCodeSearchedData(barCode: String) {
        if Reachability.isConnectedToNetwork() { // check internet connectivity
            self.view.showLoading(centreToView: self.view)
            viewModel.getBarCodeSearchedData(barCode: barCode,
                complition: { isTrue, showMessage in
                    if isTrue {
                        DispatchQueue.main.async {
                            self.view.stopLoading()
                            self.tblSearchTableView.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.view.stopLoading()
                            self.view.endEditing(true) // for dismiss the keyboard
                            self.tblSearchTableView.reloadData()
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
// MARK: -
extension SearchVC {
    func setTableView() {
        self.tblSearchTableView.separatorColor = UIColor.clear
        self.tblSearchTableView.delegate = self
        self.tblSearchTableView.dataSource = self
        self.tblSearchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
    }
    func setFont() {
        self.lblScan.font = UIFont.setFont(fontType: .medium, fontSize: .twelve)
        self.lblScan.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.imgScan.image = UIImage(named: SCAN_UNSELECTED_ICON)
        self.lblFindRfid.font = UIFont.setFont(fontType: .medium, fontSize: .twelve)
        self.lblFindRfid.textColor = UIColor.setColor(colorType: .lblTextPara)
        self.imgFindRfid.image = UIImage(named: FIND_UNSELECT_ICON)
        self.lblSearch.font = UIFont.setFont(fontType: .medium, fontSize: .twelve)
        let gradient = getGradientLayer(bounds: view.bounds)
        self.lblSearch.textColor = gradientColor(bounds: view.bounds, gradientLayer: gradient)
        self.imgSearch.image = UIImage(named: SEARCH_SELECTED_ICON)
        self.lblSearchText.font = UIFont.setFont(fontType: .regular, fontSize: .fourteen)
        self.lblSearchText.textColor = UIColor.setColor(colorType: .tgBlack)
    }
    @objc func btnCheckInAction(_ sender: UIButton) {
        self.view.alpha = 0.5
        self.view.backgroundColor = .black
        print("btn check in", sender.tag)
        if let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "EmailSearchPopupViewController") as? EmailSearchPopupViewController {
            popoverContent.popupDelegate = self
            popoverContent.viewModel.arrEmailOrder = viewModel.arrGetEmailOrdersResponse?[sender.tag].barcodeData ?? []
            viewModel.orderId = viewModel.arrGetEmailOrdersResponse?[sender.tag].orderID ?? ""
            let nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true, completion: nil)
        }
    }
}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.textField.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrGetEmailOrdersResponse?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        let record = viewModel.arrGetEmailOrdersResponse?[indexPath.row]
        if let firstName = record?.firstName, let lastName = record?.lastName {
            cell.lblName.text = "\(firstName) \(lastName)"
        }
        if (record?.barcodeData?.isEmpty ?? false) {
            cell.btnCheckIn.setTitle("Checked In", for: .normal)
            cell.btnCheckIn.addLeftIcon(image: UIImage(named: "check-circle"))
            cell.btnCheckIn.alpha = 0.5
            cell.btnCheckIn.isUserInteractionEnabled = false
        } else {
            cell.btnCheckIn.setTitle("Check In", for: .normal)
            cell.btnCheckIn.removeLeftIcon()
            cell.btnCheckIn.alpha = 1
            cell.btnCheckIn.isUserInteractionEnabled = true
        }
        cell.lblCardNo.text = "Card No. " + ((((record?.cardNumber?.isEmpty) != nil) ? "NA" : record?.cardNumber) ?? "")
        cell.lblNameOnCard.text = "Name on Card: " + (record?.nameOnCard ?? "NA")
        cell.lblOrderId.text = "Order Id: " + (record?.orderID ?? "NA")
        cell.btnCheckIn.tag = indexPath.row
        cell.btnCheckIn.addTarget(self, action: #selector(self.btnCheckInAction(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195
    }
}
// MARK: - Instance Method
extension SearchVC {
    func setUI() {
        [self.btnSearch, self.btnScan, self.btnFindRfid, self.btnBack].forEach {
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
        case btnBack:
            self.btnBackAction()
        default:
            break
        }
    }
    func btnScanAction() {
        if let view = createView(storyboard: .main, storyboardID: .ScannerVC) as? ScannerVC {
            // Send data back to previous screen
            view.viewModel.updateTicketModel = viewModel.updateTicketModel
            self.navigationController?.pushViewController(view, animated: false)
        }
    }
    func btnFindRfidAction() {
        if let view = createView(storyboard: .main, storyboardID: .FindRFIDVC) as? FindRFIDVC {
            // Send data back to previous screen
            view.viewModel.updateTicketModel = viewModel.updateTicketModel
            self.navigationController?.pushViewController(view, animated: false)
        }
    }
    func btnSearchAction() {
        print("search")
    }
    func btnBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchVC: DidPopupDismis {
    // After dismiss the popup we set the data and reset screen UI by delegate methods
    func updateDataAfterPopupDismissed(isFromCancel: Bool,
                                       selectedBarCodes: String) {
        self.view.alpha = 1
        self.view.backgroundColor = .clear
        print("email:- ",viewModel.emailId)
        if !isFromCancel {
            // Call API to update confirm email order and get entry.
            updateEmailEntry(selectedBarCode: selectedBarCodes)
        }
    }
}
extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return tapped ", textField.text as Any)
        print("\(String(describing: lblSearchText.text))")
        
        if let searchText = textField.text, !searchText.isEmpty {
            if searchText.isValidEmail(emaiId: searchText) {
                print("email API call")
                getEmailSearchedData(email: "sanjay.chawke@gmail.com")
                viewModel.emailId = "sanjay.chawke@gmail.com"
            } else if searchText.isContainsOnlyNumber {
                print("bar code API call")
                getBarCodeSearchedData(barCode: searchText)
            } else {
                print("global API call")
            }
        } else {
            self.showToast(message: "Please enter keyword to search")
        }
        return  true
    }
}
