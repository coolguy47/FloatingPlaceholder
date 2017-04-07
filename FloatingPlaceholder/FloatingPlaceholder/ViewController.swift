//
//  ViewController.swift
//  FloatingPlaceholder
//
//  Created by Jeremiah on 07/04/17.
//  Copyright © 2017 Jeremiah. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var textfieldUsername: FloatingPlaceholderView!
    @IBOutlet weak var textfieldPassword: FloatingPlaceholderView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldUsername.textfield.delegate = self
        textfieldPassword.textfield.delegate = self

        // Do any additional setup after loading the view, typically from a nib.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

