//
//  CRClientNameTableViewCell.swift
//  ClientRecords
//
//  Created by sawyer3x on 17/4/19.
//  Copyright © 2017年 sawyer3x. All rights reserved.
//

import UIKit

class CRClientNameTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
 
    ///接收的数据模型
    var clientModel: CRClientInfoModel? {
        didSet{
            ///设置 客户名称
            if clientModel?.name != "" {
                nameLabel.text = clientModel?.name
            }else {
                nameLabel.text = ""
            }

        }
    }
    
}
