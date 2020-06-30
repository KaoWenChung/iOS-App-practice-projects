//
//  HospitalDetailViewController.swift
//  maskMapV3
//
//  Created by wyn on 2020/6/27.
//  Copyright © 2020 Wyn. All rights reserved.
//

import UIKit

class HospitalDetailViewController: UIViewController {
    var masks: Mask!
    @IBOutlet var maskDetailView: MaskDetailView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maskDetailView.nameLabel.text = masks.name
        maskDetailView.adultLabel.text = String(masks.adultCount)
        maskDetailView.childLabel.text = String(masks.childCount)
        maskDetailView.addressLabel.text = masks.address
        maskDetailView.telLabel.text = masks.tel

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
