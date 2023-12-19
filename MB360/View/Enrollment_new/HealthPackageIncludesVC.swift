//
//  HealthPackageIncludesVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 29/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class HealthPackageIncludesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var testarray = [packageIncludesModel]()

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        btnGotIt.makeCicularWithMasks()
//                   btnGotIt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                   btnGotIt.layer.borderWidth = 1.0
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        tableView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.layer.borderWidth = 1.0
        tableView.layer.cornerRadius = 12.0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        testarray.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "PackageIncludeHCCell", for: indexPath) as! PackageIncludeHCCell
        cell.lblFirst.text = testarray[indexPath.row].DIAG_PKG_TEST_NAME
        cell.lblLast.text = testarray[indexPath.row].DIAG_PKG_TEST_DESC


        
        return cell
       }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
