//
//  ScanSummaryTableViewCell.swift
//  TicketGateway
//
//  Created by Apple on 05/10/23.
//

import UIKit

class ScanSummaryTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
        @IBOutlet weak var lblTicketId: UILabel!
        @IBOutlet weak var lblStatus: UILabel!
        @IBOutlet weak var lblScannedDate: UILabel!
        @IBOutlet weak var lblScannedTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data:GetScanSummaryItem){
        lblTicketId.text = "\(data.orderTicketsId ?? 0)"
        lblStatus.text = data.status == true ? "Accepted" : "Rejected"
        lblScannedDate.text = self.getDate(strDate: data.createdAt ?? "")
        lblScannedTime.text = self.getTime(strDate: data.createdAt ?? "")
    }
    
    func getTime(strDate: String) -> String {
        let date = strDate.convertStringToDate(date: strDate)
        return date.getOnlyTimeFromDate(date: date)
    }
    func getDate(strDate: String) -> String {
        let date = strDate.convertStringToDate(date: strDate)
        return date.convertToString()
        //return date.getWeekDay(date: date) ?? "-"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
