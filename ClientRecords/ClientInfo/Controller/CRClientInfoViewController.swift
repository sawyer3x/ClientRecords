//
//  CRClientInfoViewController.swift
//  ClientRecords
//
//  Created by sawyer3x on 17/4/19.
//  Copyright © 2017年 sawyer3x. All rights reserved.
//

import UIKit

///控制器类型枚举定义
enum ClientInfoControllerType {
    case Add //添加
    case Edit //编辑
}

///cell重用标识符
private let CRDetailInfoCellReuseIdentifier = "CRDetailInfoCellReuseIdentifier"

class CRClientInfoViewController: UIViewController {

    ///对外提供的类工厂方法
    class func instance(type: ClientInfoControllerType) -> CRClientInfoViewController {
        let vc = CRClientInfoViewController()
        vc.controllerType = type
        return vc
    }

    //MARK: - 懒加载集合
    ///控制器类型
    fileprivate var controllerType: ClientInfoControllerType?

    var oneClient: Client?
    
    fileprivate var clientInfoArrM = NSMutableArray()

    var totalClientInfoArrM = NSMutableArray()
    
    fileprivate var titleArr = ["门市规模", "产品份额", "仓库规模", "产品份额", "主营产品", "客户类型", "质量要求", "价格要求", "服务态度", "合作意愿", "其他合作者", "产品份额", "备注", "记录人"]
    
    fileprivate var tableCell = CRTableViewCell()

    ///图片选择器
    fileprivate lazy var imagePickerController: UIImagePickerController? = {
        let imageVC = UIImagePickerController()
        imageVC.allowsEditing = true
        imageVC.delegate = self
        return imageVC
    }()

    //MARK: - xib链接控件
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var clientNameTF: UITextField!    
    @IBOutlet weak var marketTF: UITextField!
    @IBOutlet weak var recordTimeTF: UITextField!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addCardBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clickAddCardBtn(_ sender: Any) {
        print("clickAddCardBtn")
        showImagePickerController(.camera)
    }
    
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
        
        clientToArrM()
        
        setupTotalArrM()
        
        setupUI()
        
        setupTableView()
    }
    
    fileprivate func clientToArrM() {
        clientInfoArrM.add(oneClient?.marketSize ?? "")
        clientInfoArrM.add(oneClient?.productShareOfMarket ?? "")
        clientInfoArrM.add(oneClient?.repertorySize ?? "")
        clientInfoArrM.add(oneClient?.productShareOfRepertory ?? "")
        clientInfoArrM.add(oneClient?.majorProduct ?? "")
        clientInfoArrM.add(oneClient?.clientType ?? "")
        clientInfoArrM.add(oneClient?.qualityRequirement ?? "")
        clientInfoArrM.add(oneClient?.priceRequirement ?? "")
        clientInfoArrM.add(oneClient?.serviceAttitude ?? "")
        clientInfoArrM.add(oneClient?.cooperationInterests ?? "")
        clientInfoArrM.add(oneClient?.otherCooperators ?? "")
        clientInfoArrM.add(oneClient?.productShareOfOtherCooperators ?? "")
        clientInfoArrM.add(oneClient?.remarks ?? "")
        clientInfoArrM.add(oneClient?.recorder ?? "")
    }
    
    fileprivate func setupTotalArrM() {
        //TODO: - 不包括名片data
        totalClientInfoArrM.add(oneClient?.name ?? "")
        totalClientInfoArrM.add(oneClient?.market ?? "")
        totalClientInfoArrM.add(oneClient?.recordTime ?? "")

        for item in clientInfoArrM {
            totalClientInfoArrM.add(item)
        }
    }
    
    fileprivate func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(CRClientInfoViewController.clickSave))

        clientNameTF.text = oneClient?.name ?? ""
        marketTF.text = oneClient?.market ?? ""
        recordTimeTF.text = oneClient?.recordTime ?? ""
        //TODO: - imageview 名片
        if oneClient?.bussinessCard != nil {
            imageView.image = UIImage(data: oneClient?.bussinessCard as! Data)
        } else {
            imageView.image = nil
        }
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
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //注册cell
        tableView.register(UINib(nibName: "CRTableViewCell", bundle: nil), forCellReuseIdentifier: CRDetailInfoCellReuseIdentifier)
    }
    
    //MARK: - 展示图片选择界面
    fileprivate func showImagePickerController(_ type: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            //设置类型
            imagePickerController?.sourceType = type
            
            //展示界面
            navigationController!.present(imagePickerController!, animated: true, completion: {
            })
        }
    }

    func clickSave() {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "请选择", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "保存信息", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.saveClientInfo()
            print("File 保存信息")
        })
        let saveAction = UIAlertAction(title: "保存为图片", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.savePhoto()
            print("File 保存为图片")
        })
        
        //
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func saveClientInfo() {
        let imageData: NSData!
        
        if imageView.image != nil {
            imageData = NSData(data: UIImagePNGRepresentation(imageView.image!)!)
        } else {
            imageData = nil
        }
        
        HandleCoreData.addNewClient(id: "00001", name: "测试", market: "精品广场12", recordTime: "2017.04.21", bussinessCard: imageData, marketSize: "大", productShareOfMarket: "50%", repertorySize: "大", productShareOfRepertory: "50%", majorProduct: "布", clientType: "啊", qualityRequirement: "低", priceRequirement: "低", serviceAttitude: "很棒", cooperationInterests: "好", otherCooperators: "无", productShareOfOtherCooperators: "0", remarks: "无", recorder: "yzh")
    }
    
    func savePhoto() {
        ////TODO: - 不完整 目前仅保存了图片
        //保存照片
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(CRClientInfoViewController.didFinishSaveImageWithError(_:error:contextInfo:)), nil)
    }
    
    //MARK: - 保存照片后的回调方法
    func didFinishSaveImageWithError(_ image: UIImage?, error: NSError?, contextInfo: AnyObject) {
        if error == nil {
            //TODO: - hud
            print("保存成功")
        }else {
            print("保存失败")
        }
    }

    func pop() {
       _ = navigationController?.popViewController(animated: true)
    }
    
}

extension CRClientInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //获取重用Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CRDetailInfoCellReuseIdentifier) as! CRTableViewCell
        
        cell.titleLabel.text = titleArr[indexPath.row]
        cell.detailLabel.text = clientInfoArrM[indexPath.row] as? String
        
        return cell
    }
    
}

extension CRClientInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to:#selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click the no.\(indexPath.row) row")
        
        let inputVC = CRInputViewController()
        inputVC.navTitle = titleArr[indexPath.row]
        inputVC.selectedRow = indexPath.row
        
        navigationController?.pushViewController(inputVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}


//MARK: - UIImagePickerControllerDelegate
extension CRClientInfoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //获取图片
        let selectedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        
        //退出图片选择控制器控制器
        picker.dismiss(animated: true) {
        }
        
        //如果图片不为空，上传图片
        if selectedImage != nil {
            imageView.image = selectedImage
        }
    }

}

//MARK: - 文本框相关方法
extension CRClientInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //获取字符串
        let str = textField.text
        
        switch textField {
        case clientNameTF:
            totalClientInfoArrM[0] = str ?? totalClientInfoArrM[0]
        case marketTF:
            totalClientInfoArrM[1] = str ?? totalClientInfoArrM[1]
        case recordTimeTF:
            totalClientInfoArrM[2] = str ?? totalClientInfoArrM[2]          
        default:
            break
        }
        print("------total = \(totalClientInfoArrM)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


