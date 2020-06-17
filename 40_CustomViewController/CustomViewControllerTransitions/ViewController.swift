//
//  ViewController.swift
//  CustomViewControllerTransitions
//
//  Created by wyn on 2020/5/18.
//  Copyright © 2020 Wyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View did load called in ViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear has been called in ViewController")
    }

    @IBAction func executeTransition(_ sender: Any) {
        
        guard let destinationVC = storyboard?.instantiateViewController(withIdentifier: "ViewControllerTwo") as? ViewControllerTwo else { return }
        present(destinationVC, animated: true, completion: nil)
    }
    

}

