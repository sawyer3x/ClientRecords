//
//  CRTableViewCell.swift
//  ClientRecord
//
//  Created by sawyer3x on 17/4/18.
//  Copyright © 2017年 sawyer3x. All rights reserved.
//

import UIKit

class CRTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var titleModel: CRTableInfoModel? {
        didSet{
            //设置标题
            if titleModel!.cellTitle != "" {
                titleLabel.text = titleModel!.cellTitle
            }else {
                titleLabel.text = "---"
            }
            
            //设置内容
            if titleModel!.cellContent != "" {
                detailLabel.text = titleModel!.cellContent
            }else {
                detailLabel.text = "---"
            }
        }
    }
}
