//
//  EditViewController.swift
//  Sante
//
//  Created by Admin on 21/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var preferenceSystem: UILabel!
    @IBOutlet weak var whatFirst: UILabel!
    @IBOutlet weak var segmentedFirst: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        preferenceSystem.text = "Preference System"
        whatFirst.text = "Position of Name"
    
        guard let isNameFirst = UserDefaults.standard.value(forKey: "isNameFirst") as? Int else {
            segmentedFirst.selectedSegmentIndex = 1
            return
        }
        segmentedFirst.selectedSegmentIndex = isNameFirst
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        let preferenceFirstChoice = segmentedFirst.selectedSegmentIndex
        
        UserDefaults.standard.set(preferenceFirstChoice, forKey: "isNameFirst")
        
        dismiss(animated: true, completion: nil)
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
