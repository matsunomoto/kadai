//
//  ItemTableViewCell.swift
//  MyOkashi
//
//  Created by User4 on 2018/03/17.
//  Copyright © 2018年 User4. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell  {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemMakerLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
