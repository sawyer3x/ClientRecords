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
    ///tableView标题、内容数组
    fileprivate var titles: [[[String?]]]?
    ///标题cell的数据模型
    fileprivate var infoModels: [[CRTableInfoModel?]]?
    
    var oneClient: Client?
    
    var clientOriginName: String?
    var clientName: String?
    var clientMarket: String?
    var recordTime: String?
        
//    fileprivate var titleArr = ["门市规模", "产品份额", "仓库规模", "产品份额", "主营产品", "客户类型", "质量要求", "价格要求", "服务态度", "合作意愿", "其他合作者", "产品份额", "备注", "记录人"]
    
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
    
    //照片按钮点击
    @IBAction func clickAddCardBtn(_ sender: Any) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "请选择", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "拍照", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showImagePickerController(.camera)
        })
        let saveAction = UIAlertAction(title: "打开相册", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showImagePickerController(.photoLibrary)
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置主要数据
        setupMainInfo()
        
        //初始化UI
        setupUI()
        
        //初始化设置tableView
        setupTableView()
    }

    func setupMainInfo() {
        let clientName = oneClient?.name ?? ""
        let clientMarket = oneClient?.market ?? ""
        let recordTime = oneClient?.recordTime ?? ""
        let marketSize = oneClient?.marketSize ?? ""
        let productShareOfMarket = oneClient?.productShareOfMarket ?? ""
        let repertorySize = oneClient?.repertorySize ?? ""
        let productShareOfRepertory = oneClient?.productShareOfRepertory ?? ""
        let majorProduct = oneClient?.majorProduct ?? ""
        let clientType = oneClient?.clientType ?? ""
        let qualityRequirement = oneClient?.qualityRequirement ?? ""
        let priceRequirement = oneClient?.priceRequirement ?? ""
        let serviceAttitude = oneClient?.serviceAttitude ?? ""
        let cooperationInterests = oneClient?.cooperationInterests ?? ""
        let otherCooperators = oneClient?.otherCooperators ?? ""
        let productShareOfOtherCooperators = oneClient?.productShareOfOtherCooperators ?? ""
        let remarks = oneClient?.remarks ?? ""
        let recorder = oneClient?.recorder ?? ""

        self.titles = [[["客户", clientName],
                        ["市场", clientMarket],
                        ["记录时间", recordTime]],
                       [["门市规模", marketSize],
                        ["产品份额", productShareOfMarket],
                        ["仓库规模", repertorySize],
                        ["产品份额", productShareOfRepertory],
                        ["主营产品", majorProduct],
                        ["客户类型", clientType],
                        ["质量要求", qualityRequirement],
                        ["价格要求", priceRequirement],
                        ["服务态度", serviceAttitude],
                        ["合作意愿", cooperationInterests],
                        ["其他合作者", otherCooperators],
                        ["产品份额", productShareOfOtherCooperators],
                        ["备注", remarks],
                        ["记录人", recorder]]]
        
        //创建数据模型数组
        infoModels = [[CRTableInfoModel?]]()
        
        for section in 0...(titles!.count - 1) {
            
            //获取当前标题小数组
            let strArrArr = titles![section] as [[String?]]
            
            //遍历数组，创建数据源数组
            var modelArr =  [CRTableInfoModel?]()
            for item in 0...(strArrArr.count - 1) {
                let strArr = strArrArr[item]
                let model = CRTableInfoModel.titleModel(title: strArr[0]!, content: strArr[1])
                modelArr.append(model)
            }
            infoModels!.append(modelArr)
        }
    }
    
    fileprivate func setupUI() {
        navigationItem.title = "亚洲红客户拜访纪录表"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(CRClientInfoViewController.clickSave))
        
        //TODO: - 可能改成字典比较好
        clientNameTF.text = infoModels?[0][0]?.cellContent
        marketTF.text = infoModels?[0][1]?.cellContent
        recordTimeTF.text = infoModels?[0][2]?.cellContent
        //TODO: - imageview 名片
        if oneClient?.bussinessCard != nil {
            imageView.image = UIImage(data: oneClient?.bussinessCard! as! Data)
        } else {
//            imageView.image = nil
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

        tableView.showsVerticalScrollIndicator = false
        
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
    
    //MARK: - 保存照片后的回调方法
    func didFinishSaveImageWithError(_ image: UIImage?, error: NSError?, contextInfo: AnyObject) {
        if error == nil {
            let alertController = UIAlertController(title: "保存成功!",
                                                    message: nil, preferredStyle: .alert)
            //显示提示框
            self.present(alertController, animated: true, completion: nil)
            //两秒钟后自动消失
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)

            }
        } else {
            let alertController = UIAlertController(title: "保存失败!",
                                                    message: nil, preferredStyle: .alert)
            //显示提示框
            self.present(alertController, animated: true, completion: nil)
            //两秒钟后自动消失
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    //保存按钮点击
    func clickSave() {
        self.view.endEditing(true)

        // 1
        let optionMenu = UIAlertController(title: nil, message: "请选择", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "保存信息", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            switch self.controllerType! {
            case .Edit:
                self.updateClientInfo()
                print("更新信息")
            case .Add:
                self.saveClientInfo()
                print("保存信息")
            }
        })
        let saveAction = UIAlertAction(title: "保存信息为图片", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.savePhoto()
            print("保存信息为图片")
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
    
    func updateClientInfo() {
        updateClient()
    }
    
    func updateClient() {
        let imageData: NSData!
        
        if imageView.image != nil {
            imageData = NSData(data: UIImagePNGRepresentation(imageView.image!)!)
        } else {
            imageData = nil
        }
        
        if clientName != (infoModels?[0][0]?.cellContent)! {
            clientOriginName = (infoModels?[0][0]?.cellContent)!
        }
        
        HandleCoreData.updateClient(originName: clientOriginName ?? (infoModels?[0][0]?.cellContent)!,
                                    newName: clientName ?? (infoModels?[0][0]?.cellContent)!,
                                    market: clientMarket ?? (infoModels?[0][1]?.cellContent)!,
                                    recordTime: recordTime ?? (infoModels?[0][2]?.cellContent)!,
                                    bussinessCard: imageData,
                                    marketSize: (infoModels?[1][0]?.cellContent)!,
                                    productShareOfMarket: (infoModels?[1][1]?.cellContent)!,
                                    repertorySize: (infoModels?[1][2]?.cellContent)!,
                                    productShareOfRepertory: (infoModels?[1][3]?.cellContent)!,
                                    majorProduct: (infoModels?[1][4]?.cellContent)!,
                                    clientType: (infoModels?[1][5]?.cellContent)!,
                                    qualityRequirement: (infoModels?[1][6]?.cellContent)!,
                                    priceRequirement: (infoModels?[1][7]?.cellContent)!,
                                    serviceAttitude: (infoModels?[1][8]?.cellContent)!,
                                    cooperationInterests: (infoModels?[1][9]?.cellContent)!,
                                    otherCooperators: (infoModels?[1][10]?.cellContent)!,
                                    productShareOfOtherCooperators: (infoModels?[1][11]?.cellContent)!,
                                    remarks: (infoModels?[1][12]?.cellContent)!,
                                    recorder: (infoModels?[1][13]?.cellContent)!)
        
        let alertController = UIAlertController(title: "修改成功!",
                                                message: nil, preferredStyle: .alert)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
        //两秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
            self.presentedViewController?.dismiss(animated: false, completion: self.pop)
        }
    }
    
    func saveClientInfo() {
        let imageData: NSData!
        
        if imageView.image != nil {
            imageData = NSData(data: UIImagePNGRepresentation(imageView.image!)!)
        } else {
            imageData = nil
        }
        
        //TODO: - 暂时未作信息是否为空的判断
        //if checkInfo() == false {
        HandleCoreData.addNewClient(name: clientName ?? (infoModels?[0][0]?.cellContent)!,
                                    market: clientMarket ?? (infoModels?[0][1]?.cellContent)!,
                                    recordTime: recordTime ?? (infoModels?[0][2]?.cellContent)!,
                                    bussinessCard: imageData,
                                    marketSize: (infoModels?[1][0]?.cellContent)!,
                                    productShareOfMarket: (infoModels?[1][1]?.cellContent)!,
                                    repertorySize: (infoModels?[1][2]?.cellContent)!,
                                    productShareOfRepertory: (infoModels?[1][3]?.cellContent)!,
                                    majorProduct: (infoModels?[1][4]?.cellContent)!,
                                    clientType: (infoModels?[1][5]?.cellContent)!,
                                    qualityRequirement: (infoModels?[1][6]?.cellContent)!,
                                    priceRequirement: (infoModels?[1][7]?.cellContent)!,
                                    serviceAttitude: (infoModels?[1][8]?.cellContent)!,
                                    cooperationInterests: (infoModels?[1][9]?.cellContent)!,
                                    otherCooperators: (infoModels?[1][10]?.cellContent)!,
                                    productShareOfOtherCooperators: (infoModels?[1][11]?.cellContent)!,
                                    remarks: (infoModels?[1][12]?.cellContent)!,
                                    recorder: (infoModels?[1][13]?.cellContent)!)
        
            let alertController = UIAlertController(title: "保存成功!",
                                                    message: nil, preferredStyle: .alert)
            //显示提示框
            self.present(alertController, animated: true, completion: nil)
            //两秒钟后自动消失
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                self.presentedViewController?.dismiss(animated: false, completion: self.pop)
            }
        //}
    }
    
    //TODO: - 暂时未作信息是否为空的判断
    func checkInfo() -> Bool{
        if infoModels?[0][0]?.cellContent == "" {
            let alert = UIAlertController(title: "请填写客户名称", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[0][1]?.cellContent == "" {
            let alert = UIAlertController(title: "请填写市场", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[0][2]?.cellContent == "" {
            let alert = UIAlertController(title: "请填写记录时间", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][0]?.cellContent == "" {
            let alert = UIAlertController(title: "请填写门市规模", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][1]?.cellContent == "" {
            let alert = UIAlertController(title: "请填写产品份额", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][2]?.cellContent  == "" {
            let alert = UIAlertController(title: "请填写仓库规模", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][3]?.cellContent  == "" {
            let alert = UIAlertController(title: "请填写产品份额", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][4]?.cellContent  == "" {
            let alert = UIAlertController(title: "请填写主营产品", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][5]?.cellContent  == "" {
            let alert = UIAlertController(title: "请填写客户类型", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][6]?.cellContent  == "" {
            let alert = UIAlertController(title: "请填写质量要求", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][7]?.cellContent  == "" {
            let alert = UIAlertController(title: "请填写价格要求", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][8]?.cellContent  == "" {
            let alert = UIAlertController(title: "请填写服务态度", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][9]?.cellContent  == "" {
            let alert = UIAlertController(title: "请填写合作意愿", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][10]?.cellContent  == "" {
            let alert = UIAlertController(title: "请填写其他合作者", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][11]?.cellContent  == "" {
            let alert = UIAlertController(title: "请填写产品份额", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][12]?.cellContent  == "" {
            let alert = UIAlertController(title: "请填写备注", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        if infoModels?[1][13]?.cellContent  == "" {
            let alert = UIAlertController(title: "请填写记录人", message: nil,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    func savePhoto() {
        ////TODO: - 不完整 目前仅保存了图片
        //保存照片
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(CRClientInfoViewController.didFinishSaveImageWithError(_:error:contextInfo:)), nil)
    }

    func pop() {
       _ = navigationController?.popViewController(animated: true)
    }
    
}

extension CRClientInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoModels![1].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //获取重用Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: CRDetailInfoCellReuseIdentifier) as! CRTableViewCell
        
        //取出模型，传递模型
        cell.titleModel = infoModels![1][indexPath.row]! as CRTableInfoModel
        
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
        //取出模型，跳转编辑界面
        let model = infoModels![1][indexPath.row]!
        let editVC = CRInputViewController.editInfo(titleInfoModel: model)
        
        navigationController?.pushViewController(editVC, animated: true)
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
            clientName = str ?? (infoModels?[0][0]?.cellContent)!
        case marketTF:
            clientMarket = str ?? (infoModels?[0][1]?.cellContent)!
        case recordTimeTF:
            recordTime = str ?? (infoModels?[0][2]?.cellContent)!
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


