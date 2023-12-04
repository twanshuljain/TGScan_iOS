//
//  ScanAllTableViewCell.swift
//  TicketGateway
//
//  Created by Apple on 22/06/23.
//

import UIKit

class ScanAllTableViewCell: UITableViewCell {

//MARK: - Outlets
    @IBOutlet weak var vwColorView: UIView!
    @IBOutlet weak var lblSummaryTitle: UILabel!
    @IBOutlet weak var lblTitleValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setFont()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setFont() {
        lblSummaryTitle.font = UIFont.setFont(fontType: .regular, fontSize: .fourteen)
        lblSummaryTitle.textColor = UIColor.setColor(colorType: .lblTextPara)
        lblTitleValue.font = UIFont.setFont(fontType: .semiBold, fontSize: .seventeen)
    }

}
