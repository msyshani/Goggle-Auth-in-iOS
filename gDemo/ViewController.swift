//
//  ViewController.swift
//  gDemo
//
//  Created by Mahendra Yadav on 1/4/16.
//  Copyright (c) 2016 Appstudioz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MSYGoogleAuth.sharedInstance().loginWithGooglewithCompletion { (success, userData) -> Void in
            
            if(success){
               print(userData);
            }else{
               print("error in retriving data")
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

