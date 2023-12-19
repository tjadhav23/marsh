//
//  SodexoPlansTableViewCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 17/01/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

protocol SodexoPlansCollectionViewProtocol {
    func planChangeTapped(index:Int)
}


class SodexoPlansTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
        
       //  @IBOutlet weak var backgroundView1: UIView!
        // @IBOutlet weak var lblName: UILabel!

         var sodexoCollectionViewdDelegate : SodexoPlansCollectionViewProtocol? = nil
         
        
       // var selectedPlanIndex = 2
        var plansArray = [Int]()
    
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }




    //COLLECTION VIEW....
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return plansArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellForSodexo", for: indexPath) as! CollectionViewCellForSodexo
            
            
            cell.lblname.text = String(format: "₹ %@",String(plansArray[indexPath.row]))
            
            if indexPath.row == selectedPlanIndex {
                cell.btnCheck.setImage(UIImage(named: "checked"), for: .normal)

            }
            else {
                cell.btnCheck.setImage(UIImage(named: "unchecked"), for: .normal)
            }
                cell.backgroundview.clipsToBounds = true
                cell.backgroundview.layer.cornerRadius = 6.0
            cell.backgroundview.layer.borderWidth = 1.0
            cell.backgroundview.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            //cell.backgroundview.setGradientBackground1(colorTop: Color.redBottom.value, colorBottom:Color.redTop.value)
          
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            

            if sodexoCollectionViewdDelegate != nil {
                sodexoCollectionViewdDelegate?.planChangeTapped(index: indexPath.row)
            }
            
            selectedPlanIndex = indexPath.row
            
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        

    }


class CollectionViewCellForSodexo: UICollectionViewCell {
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var backgroundview: UIView!
}
