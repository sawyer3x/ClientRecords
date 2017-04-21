//
//  CRClientInfoModel.swift
//  ClientRecords
//
//  Created by sawyer3x on 17/4/20.
//  Copyright © 2017年 sawyer3x. All rights reserved.
//

import UIKit

class CRClientInfoModel: NSObject {

    ///存放客户数据模型数组单例
    static let models = NSMutableArray()
    
    //MARK: - 对外提供的返回数据模型数组的类方法
    class func modelArr() -> NSMutableArray {
        return models
    }

    ///客户名字
    var name: String?
    
    ///市场
    var market: String?
    
    ///记录时间
    var recordTime: String?
    
    ///名片
    var bussinessCard: Data?
    
    ///门市规模
    var marketSize: String?

    ///产品份额 门市
    var productShareOfMarket: String?

    ///仓库规模
    var repertorySize: String?

    ///产品份额 仓库
    var productShareOfRepertory: String?

    ///主营产品
    var majorProduct: String?

    ///客户类型
    var clientType: String?

    ///质量要求
    var qualityRequirement: String?

    ///价格要求
    var priceRequirement: String?

    ///服务态度
    var serviceAttitude: String?

    ///合作意愿
    var cooperationInterests: String?

    ///其他合作者
    var otherCooperators: String?

    ///产品份额 其他合作者
    var productShareOfOtherCooperators: String?

    ///备注
    var remarks: String?

    ///记录人
    var recorder: String?

}
