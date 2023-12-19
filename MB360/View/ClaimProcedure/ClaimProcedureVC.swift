//
//  ClaimProcedureVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 20/10/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation
import UIKit

class ClaimProcedureVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var m_tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        m_tableView.register(UINib(nibName: "Text_ClaimProcedureCell", bundle: nil), forCellReuseIdentifier: "cell1")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = m_tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        return cell
    }
    
}
