//
//  CRMainViewController.swift
//  ClientRecord
//
//  Created by sawyer3x on 17/4/18.
//  Copyright © 2017年 sawyer3x. All rights reserved.
//

import UIKit

///cell重用标识符
private let CRClientNameCellReuseIdentifier = "CRClientNameCellReuseIdentifier"

class CRMainViewController: UIViewController {

    let refreshControl = UIRefreshControl.init()
    
    ///库存数据模型数组
     var clientModels = [Client]()
    
    //MARK: - xib链接控件
    @IBOutlet weak var tableView: UITableView!
    //MARK: - 其他方法
    fileprivate init() {
        super.init(nibName: nil, bundle: nil)
    }
    fileprivate override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        view = Bundle.main.loadNibNamed("CRMainViewController", owner: self, options: nil)![0] as! UIView
    }

    override func viewDidLoad() {
        navigationItem.title = "亚洲红客户拜访纪录表"
        
        setupUI()
        
        setupTableView()
        
        //添加刷新
        refreshControl.addTarget(self, action: #selector(CRMainViewController.refreshData), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "刷新刷新刷新")
        tableView.addSubview(refreshControl)
        refreshData()
    }
    
    func refreshData() {
        clientModels.removeAll(keepingCapacity: true)
        
        clientModels = HandleCoreData.getClients()
        
        tableView.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    fileprivate func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(CRMainViewController.addClient))
    }
    
    fileprivate func setupTableView() {
        if tableView.responds(to:#selector(setter: UITableViewCell.separatorInset)) {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        if tableView.responds(to:#selector(setter: UIView.layoutMargins)) {
            tableView.layoutMargins = UIEdgeInsets.zero
        }
        
        //设置代理数据源
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension

        //注册cell
        tableView.register(UINib(nibName: "CRClientNameTableViewCell", bundle: nil), forCellReuseIdentifier: CRClientNameCellReuseIdentifier)
    }
    
    func addClient() {
        let clientVC = CRClientInfoViewController.instance(type: .Add)

        self.navigationController?.pushViewController(clientVC, animated: true)
    }
    
}

extension CRMainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //获取重用Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CRClientNameCellReuseIdentifier) as! CRClientNameTableViewCell
                
        //取出模型
        let model = clientModels[indexPath.row]
//        cell.clientModel = model

        cell.nameLabel.text = model.name
        //设置代理
//        cell.delegate = self
        
//        cell.nameLabel.text = clientNameArr[indexPath.row]
        cell.arrowImage.image = UIImage(named: "arrow_image")
        
        return cell
    }
    
}

extension CRMainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to:#selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let clientVC = CRClientInfoViewController.instance(type: .Edit)
        clientVC.oneClient = clientModels[indexPath.row]
        
        self.navigationController?.pushViewController(clientVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //取出cell
        let cell = tableView.cellForRow(at: indexPath) as! CRClientNameTableViewCell
        
        //取出对应模型
//        let model = cell.vistModel!
        
        /*******************  删除按钮  ********************/
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
            
            /// alertVC
            let alertVC = UIAlertController(title: "确定删除？", message: nil, preferredStyle: .alert)
            
            /// cancelAction
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            })
            
            /// deleteAction
            let deleteAction = UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
                
                //删除操作
                //////

                HandleCoreData.deleteClient(name: cell.nameLabel.text!)
                
                let alertController = UIAlertController(title: "删除成功!",
                                                        message: nil, preferredStyle: .alert)
                //显示提示框
                self.present(alertController, animated: true, completion: self.refreshData)
        
                //0.8秒钟后自动消失
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
            })
            alertVC.addAction(cancelAction)
            alertVC.addAction(deleteAction)
            
            self.present(alertVC, animated: true, completion: {
            })
        }
        
        //操作数组
        return[deleteAction]
    }

}


