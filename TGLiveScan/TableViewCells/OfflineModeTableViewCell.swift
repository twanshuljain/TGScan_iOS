//
//  OfflineModeTableViewCell.swift
//  TGLiveScan
//
//  Created by apple on 11/23/23.
//

import UIKit

class OfflineModeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblOffline: UILabel!
    @IBOutlet weak var uiSwitch: UISwitch! {
        didSet {
            uiSwitch.onTintColor = .red
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        uiSwitch.setOn(false, animated: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
