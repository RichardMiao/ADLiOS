//
//  LoginViewController.swift
//  ADL
//
//  Created by Richard on 3/15/17.
//  Copyright © 2017 RichardISU Computer Science smart house lab. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let fileProcess = FileProcess()
    
    @IBOutlet weak var isuLogo: UIImageView!
    @IBOutlet weak var userNameInput: UITextField!
    
    @IBOutlet weak var userEmailInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isuLogo.image = UIImage(named:"flag2.png")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        let userName = userNameInput.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let userEmail = userEmailInput.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if userName == nil || userEmail == nil {
            return
        }
        let userInputString = userName!+"\n"+userEmail!+"@iastate.edu"
        fileProcess.wirteFileWithCoverUp(content: userInputString, fileName: "user", folder: "login")
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
