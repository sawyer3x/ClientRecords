//
//  HandleCoreData.swift
//  ClientRecords
//
//  Created by sawyer3x on 17/4/20.
//  Copyright © 2017年 sawyer3x. All rights reserved.
//

import UIKit
import CoreData

//Client对象创建成功之后，接下来就是通过对象来使用CoreData了
class HandleCoreData: NSObject {
    
    //1、插入数据的具体操作如下
    /*
     * 通过AppDelegate单利来获取管理的数据上下文对象，操作实际内容
     * 通过NSEntityDescription.insertNewObjectForEntityForName方法创建实体对象
     * 给实体对象赋值
     * 通过saveContext()保存实体对象
     */
    class func addNewClient(name: String, market: String, recordTime: String, bussinessCard: NSData?, marketSize: String, productShareOfMarket: String, repertorySize: String, productShareOfRepertory: String, majorProduct: String, clientType: String, qualityRequirement: String, priceRequirement: String, serviceAttitude: String, cooperationInterests: String, otherCooperators: String, productShareOfOtherCooperators: String, remarks: String, recorder: String) {
        
        //获取数据上下文对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //创建Client对象
        let EntityName = "Client"
        let oneClient = NSEntityDescription.insertNewObject(forEntityName: EntityName, into:context) as! Client
        
        //对象赋值
        oneClient.name = name
        oneClient.market = market
        oneClient.recordTime = recordTime
        oneClient.bussinessCard = bussinessCard ?? nil//TODO: - data nsdata???
        oneClient.marketSize = marketSize
        oneClient.productShareOfMarket = productShareOfMarket
        oneClient.repertorySize = repertorySize
        oneClient.productShareOfRepertory = productShareOfRepertory
        oneClient.majorProduct = majorProduct
        oneClient.clientType = clientType
        oneClient.qualityRequirement = qualityRequirement
        oneClient.priceRequirement = priceRequirement
        oneClient.serviceAttitude = serviceAttitude
        oneClient.cooperationInterests = cooperationInterests
        oneClient.otherCooperators = otherCooperators
        oneClient.productShareOfOtherCooperators = productShareOfOtherCooperators
        oneClient.remarks = remarks
        oneClient.recorder = recorder
        
        //保存
        app.saveContext()
    }
    
    
    //2、查询数据的具体操作如下
    /*
     * 利用NSFetchRequest方法来声明数据的请求，相当于查询语句
     * 利用NSEntityDescription.entityForName方法声明一个实体结构，相当于表格结构
     * 利用NSPredicate创建一个查询条件，并设置请求的查询条件
     * 通过context.fetch执行查询操作
     * 使用查询出来的数据
     */
    class func getClients() -> [Client] {
        
        //获取数据上下文对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.fetchLimit = 10  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "Client"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
        
        //设置查询条件
       // let predicate = NSPredicate.init(format: "")
       // fetchRequest.predicate = predicate
        
        //查询操作
        do{
            let fetchedObjects = try context.fetch(fetchRequest) as! [Client]
            
//            //遍历回传nsmutablearray的result
//            let arr = NSMutableArray()
//            arr.addObjects(from: fetchedObjects)
//            
//            return arr
//            for info: Client in fetchedObjects{
//                print("ClientName = \(info.name)")
//                print("ClientRecordTime = \(info.recordTime)")
//                print("+++++++++++++++++++++++++")
//            }

            ///返回查询到的结果
            let result = fetchedObjects
            return result
        }catch {
            let nserror = error as NSError
            fatalError("查询错误： \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    //3、修改数据的具体操作如下
    /*
     * 利用NSFetchRequest方法来声明数据的请求，相当于查询语句
     * 利用NSEntityDescription.entityForName方法声明一个实体结构，相当于表格结构
     * 利用NSPredicate创建一个查询条件，并设置请求的查询条件
     * 通过context.fetch执行查询操作
     * 将查询出来的数据进行修改,也即进行赋新值
     * 通过saveContext()保存修改后的实体对象
     */
    class func updateClient(originName: String, newName: String, market: String, recordTime: String, bussinessCard: NSData?, marketSize: String, productShareOfMarket: String, repertorySize: String, productShareOfRepertory: String, majorProduct: String, clientType: String, qualityRequirement: String, priceRequirement: String, serviceAttitude: String, cooperationInterests: String, otherCooperators: String, productShareOfOtherCooperators: String, remarks: String, recorder: String){
        
        //获取数据上下文对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.fetchLimit = 10  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "Client"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
        
        //设置查询条件
        let predicate = NSPredicate.init(format: "name = '\(originName)'", "")
        fetchRequest.predicate = predicate
        
        //查询操作
        do{
            let fetchedObjects = try context.fetch(fetchRequest) as! [Client]
            
            //遍历查询的结果
            for info:Client in fetchedObjects{
                //更新信息
                info.name = newName
                info.market = market
                info.recordTime = recordTime
                info.bussinessCard = bussinessCard ?? nil//TODO: - data nsdata???
                info.marketSize = marketSize
                info.productShareOfMarket = productShareOfMarket
                info.repertorySize = repertorySize
                info.productShareOfRepertory = productShareOfRepertory
                info.majorProduct = majorProduct
                info.clientType = clientType
                info.qualityRequirement = qualityRequirement
                info.priceRequirement = priceRequirement
                info.serviceAttitude = serviceAttitude
                info.cooperationInterests = cooperationInterests
                info.otherCooperators = otherCooperators
                info.productShareOfOtherCooperators = productShareOfOtherCooperators
                info.remarks = remarks
                info.recorder = recorder
                
                //重新保存
                app.saveContext()
            }
        }catch {
            let nserror = error as NSError
            fatalError("查询错误： \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    
    //4、删除数据的具体操作如下
    /*
     * 利用NSFetchRequest方法来声明数据的请求，相当于查询语句
     * 利用NSEntityDescription.entityForName方法声明一个实体结构，相当于表格结构
     * 利用NSPredicate创建一个查询条件，并设置请求的查询条件
     * 通过context.fetch执行查询操作
     * 通过context.delete删除查询出来的某一个对象
     * 通过saveContext()保存修改后的实体对象
     */
    class func deleteClient(name: String){
        
        //获取数据上下文对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.fetchLimit = 10  //限制查询结果的数量
        fetchRequest.fetchOffset = 0  //查询的偏移量
        
        //声明一个实体结构
        let EntityName = "Client"
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        fetchRequest.entity = entity
        
        //设置查询条件
        let predicate = NSPredicate.init(format: "name = '\(name)'", "")
        fetchRequest.predicate = predicate
        
        //查询操作
        do{
            let fetchedObjects = try context.fetch(fetchRequest) as! [Client]
            
            //遍历查询的结果
            for info:Client in fetchedObjects{
                //删除对象
                context.delete(info)
                
                //重新保存
                app.saveContext()
            }
        }catch {
            let nserror = error as NSError
            fatalError("查询错误： \(nserror), \(nserror.userInfo)")
        }
    }
}
    
