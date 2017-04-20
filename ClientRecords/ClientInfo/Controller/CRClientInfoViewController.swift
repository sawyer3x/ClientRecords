//
//  CRClientInfoViewController.swift
//  ClientRecords
//
//  Created by sawyer3x on 17/4/19.
//  Copyright © 2017年 sawyer3x. All rights reserved.
//

import UIKit

///cell重用标识符
private let CRTableViewCellReuseIdentifier = "CRTableViewCellReuseIdentifier"

class CRClientInfoViewController: UIViewController {

    //MARK: - xib链接控件
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var clientNameTF: UITextField!    
    @IBOutlet weak var marketTF: UITextField!
    @IBOutlet weak var recordTimeTF: UITextField!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
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
        view = Bundle.main.loadNibNamed("CRClientInfoViewController", owner: self, options: nil)![0] as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "亚洲红客户拜访纪录表"
        
        setupUI()
        
        setupTableView()
    }
    
    fileprivate func setupUI() {
        
    }
    
    fileprivate func setupTableView() {
        //设置代理数据源
 //       tableView.delegate = self
 //       tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //注册cell
        tableView.register(UINib(nibName: "CRTableViewCell", bundle: nil), forCellReuseIdentifier: CRTableViewCellReuseIdentifier)
    }
    
}

//extension CRClientInfoViewController: UITableViewDataSource {
//    
//}
//
//extension CRClientInfoViewController: UITableViewDelegate {
//    
//}
