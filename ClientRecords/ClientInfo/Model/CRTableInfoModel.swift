//
//  CRTableInfoModel.swift
//  ClientRecords
//
//  Created by sawyer3x on 2017/6/3.
//  Copyright © 2017年 sawyer3x. All rights reserved.
//

import UIKit

class CRTableInfoModel: NSObject {
    ///标题
    var cellTitle = ""
    ///内容
    var cellContent = ""
    
    class func titleModel(title: String, content: String?) -> CRTableInfoModel {
        
        let model = CRTableInfoModel()
        model.cellTitle = title
        if content != nil {
            model.cellContent = content!
        }
        return model
    }
}
