//
//  SearchTableViewCell.swift
//  TicketGateway
//
//  Created by Apple on 21/06/23.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
//MARK: - Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblCardNo: UILabel!
    @IBOutlet weak var lblNameOnCard: UILabel!
    @IBOutlet weak var btnCheckIn: CustomButtonGradiant!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setFont() {
        self.lblName.font = UIFont.setFont(fontType: .semiBold, fontSize: .fourteen)
        self.lblName.textColor = UIColor.setColor(colorType: .tgBlack)
        let lbls = [lblOrderId, lblCardNo, lblNameOnCard]
        for lbl in lbls {
            lbl?.font = UIFont.setFont(fontType: .regular, fontSize: .twelve)
            lbl?.textColor = UIColor.setColor(colorType: .lblTextPara)
        }
        self.btnCheckIn.titleLabel?.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.btnCheckIn.titleLabel?.textColor = UIColor.setColor(colorType: .btnDarkBlue)
    }
    
}
