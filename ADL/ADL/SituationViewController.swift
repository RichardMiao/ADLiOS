//
//  SituationViewController.swift
//  ADL
//
//  Created by Richard on 3/15/17.
//  Copyright © 2017 RichardISU Computer Science smart house lab. All rights reserved.
//

import UIKit

protocol SituationLabelDelagate {
    func situationLabel(label:String?)
}

class SituationViewController: UIViewController {
    
    @IBOutlet weak var otherLabel: UITextField!
    var delegate:SituationLabelDelagate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func optionButton(_ sender: UIButton) {
        print("button****")
        let optionContent = sender.currentTitle
        print(optionContent)
        if delegate != nil {
            print("the delegate is not null")
            delegate!.situationLabel(label: optionContent)
            self.dismiss(animated: true, completion: nil)
        }
    
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OhterLabelSubmit(_ sender: UIButton) {
        print("other text")
        let otherlabelContent = otherLabel.text
        if delegate != nil {
            print("the delegate is not null")
            delegate!.situationLabel(label: otherlabelContent)
            self.dismiss(animated: true, completion: nil)
        }
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
