//
//  CRInputViewController.swift
//  ClientRecords
//
//  Created by sawyer3x on 17/4/21.
//  Copyright © 2017年 sawyer3x. All rights reserved.
//

import UIKit

class CRInputViewController: UIViewController {

    
    //MARK: - 懒加载集合
    var navTitle: String?
    var selectedRow: Int?
    
    //MARK: - xib链接控件
    @IBOutlet weak var inputTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = navTitle
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(CRInputViewController.save))

    }
    
    func save() {
        let vc = CRClientInfoViewController()
        vc.clientInfoArrM?[selectedRow! + 3] = inputTF.text ?? ""

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
