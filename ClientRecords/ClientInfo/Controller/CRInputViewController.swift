//
//  CRInputViewController.swift
//  ClientRecords
//
//  Created by sawyer3x on 17/4/21.
//  Copyright © 2017年 sawyer3x. All rights reserved.
//

import UIKit

class CRInputViewController: UIViewController {

    //对外提供的类方法
    class func editInfo(titleInfoModel: CRTableInfoModel) -> CRInputViewController {
        
        let editVC = CRInputViewController()
        editVC.titleInfoModel = titleInfoModel
        
        return editVC
    }

    //MARK: - 属性
    ///编辑的数据模型
    fileprivate var titleInfoModel: CRTableInfoModel?
    
    //MARK: - xib链接控件
    @IBOutlet weak var inputTF: UITextField!
    
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
        //从xib加载view
        view = Bundle.main.loadNibNamed("CRInputViewController", owner: self, options: nil)![0] as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = titleInfoModel?.cellTitle
        inputTF.text = titleInfoModel?.cellContent
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(CRInputViewController.save))

    }
    
    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        inputTF.becomeFirstResponder()
    }
    
    func save() {
        inputTF.resignFirstResponder()
        titleInfoModel?.cellContent = inputTF.text!
        let _ = navigationController?.popViewController(animated: true)
    }
}

//MARK: - 文本框相关方法
extension CRInputViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //获取字符串
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
