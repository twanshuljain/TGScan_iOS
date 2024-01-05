//
//  EmailSearchPopupViewController.swift
//  TGLiveScan
//
//  Created by apple on 11/27/23.
//

import UIKit

class EmailSearchPopupViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tblViewEmailSearch: UITableView!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: CustomButtonGradiant!
    // MARK: - Variable
    var viewModel = EmailSearchPopupViewModel()
    var popupDelegate: DidPopupDismis?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    func setUI() {
        self.btnCancel.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.btnConfirm.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
    }
    @IBAction func btnCancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        popupDelegate?.updateDataAfterPopupDismissed(
            isFromCancel: true,
            selectedBarCodes: "",
            selectedIdCount: 0
        )
    }
    
    @IBAction func btnConfirmAction(_ sender: Any) {
        let selectedData = viewModel.arrEmailOrder.filter({$0.isSelected == true })
        let strSelectedBarCodes = selectedData.map {
            String($0.barcode?.trimmingCharacters(in: .whitespaces) ?? "")
        }.joined(separator: ",")
        print("strSelectedBarCodes", strSelectedBarCodes)
        self.dismiss(animated: true, completion: nil)
        self.popupDelegate?.updateDataAfterPopupDismissed(
            isFromCancel: false,
            selectedBarCodes: strSelectedBarCodes,
            selectedIdCount: selectedData.count
        )
    }
}
extension EmailSearchPopupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrEmailOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tblViewEmailSearch.dequeueReusableCell(withIdentifier: "PopupEmailSearchTableViewCell", for: indexPath) as? PopupEmailSearchTableViewCell {
            let record = viewModel.arrEmailOrder[indexPath.row]
            if let firstName = record.firstName, let lastName = record.lastName {
                cell.lblName.text = "\(firstName) \(lastName)"
            }
            cell.lblBarCodeNumber.text = record.barcode
            cell.imgCheckBox.image = UIImage(named: (record.isSelected) ? "active" : "inactive")
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.arrEmailOrder[indexPath.row].isSelected = !(viewModel.arrEmailOrder[indexPath.row].isSelected)
        tblViewEmailSearch.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
