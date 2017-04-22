//
//  Client+CoreDataProperties.swift
//  ClientRecords
//
//  Created by sawyer3x on 17/4/22.
//  Copyright © 2017年 sawyer3x. All rights reserved.
//

import Foundation
import CoreData


extension Client {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client");
    }

    @NSManaged public var bussinessCard: NSData?
    @NSManaged public var clientType: String?
    @NSManaged public var cooperationInterests: String?
    @NSManaged public var majorProduct: String?
    @NSManaged public var market: String?
    @NSManaged public var marketSize: String?
    @NSManaged public var name: String?
    @NSManaged public var otherCooperators: String?
    @NSManaged public var priceRequirement: String?
    @NSManaged public var productShareOfMarket: String?
    @NSManaged public var productShareOfOtherCooperators: String?
    @NSManaged public var productShareOfRepertory: String?
    @NSManaged public var qualityRequirement: String?
    @NSManaged public var recorder: String?
    @NSManaged public var recordTime: String?
    @NSManaged public var remarks: String?
    @NSManaged public var repertorySize: String?
    @NSManaged public var serviceAttitude: String?
    @NSManaged public var id: String?

}
