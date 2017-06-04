//
//  UserPickerViewController.swift
//  APASlapApp
//
//  Created by Jeffrey Linwood on 6/4/17.
//  Copyright © 2017 Jeff Linwood. All rights reserved.
//

import UIKit

class UserPickerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topToolbarView: UIView!
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topToolbarView.layer.shadowOffset = CGSize(width: 0, height: 0.4)
        topToolbarView.layer.shadowRadius = 4.0
        topToolbarView.layer.shadowColor = UIColor.black.cgColor
        topToolbarView.layer.shadowOpacity = 0.6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
