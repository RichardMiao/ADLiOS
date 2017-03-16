//
//  SituationViewController.swift
//  ADL
//
//  Created by Richard on 3/15/17.
//  Copyright © 2017 RichardISU Computer Science smart house lab. All rights reserved.
//

import UIKit

class SituationViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func SituButton(_ sender: UIButton) {
        print("the button clicked");
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
