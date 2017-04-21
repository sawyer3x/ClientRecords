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
    
    ///接收的数据模型
    var clientModel: CRClientInfoModel? {
        didSet{
//            //设置 客户名称
//            if clientModel?.name != "" {
//                customerLabel.text = vistModel?.CGUnitName
//            }else {
//                customerLabel.text = "---"
//            }
//            
//            //设置 日期
//            if vistModel?.startDate != "" {
//                dateLabel.text = vistModel?.startDate
//            }else {
//                dateLabel.text = "---"
//            }
//            
//            //设置 回访内容
//            if vistModel?.strContent != "" {
//                contentLabel.text = vistModel?.strContent
//            }else {
//                contentLabel.text = "---"
//            }
        }
    }
    
}
