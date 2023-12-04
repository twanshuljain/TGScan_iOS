//
//  PopupEmailSearchTableViewCell.swift
//  TGLiveScan
//
//  Created by apple on 11/27/23.
//

import UIKit

class PopupEmailSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBarCodeNumber: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var imgCheckBox: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblName.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.lblName.textColor = UIColor.setColor(colorType: .tgBlack)
        self.lblBarCodeNumber.font = UIFont.setFont(fontType: .medium, fontSize: .fourteen)
        self.lblBarCodeNumber.textColor = UIColor.setColor(colorType: .tgBlack)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
