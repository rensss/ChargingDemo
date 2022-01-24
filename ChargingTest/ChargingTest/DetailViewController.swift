//
//  DetailViewController.swift
//  ChargingTest
//
//  Created by Rzk on 2022/1/24.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var battery: Battery? {
        get {
            return self.battery
        }
        set {
            if let url = newValue?.previewVideo?.url {
                myPrint(url)
//                let task = sessionManager.download(url)
            }
        }
    }
    
}
