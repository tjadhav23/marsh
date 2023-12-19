//
//  FAQTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 18/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
class ExpandedCell
{
    var title : String?
    var answer : String?
    var expanded : Bool
    
    init(title:String,answer:String)
    {
        self.title = title
        self.answer = answer
        self.expanded = false
    }
}

class FAQTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupFontUI()
    }

    @IBOutlet weak var m_backGroundView: UIView!
    @IBOutlet weak var m_answerBackgroundView: UIView!
    @IBOutlet weak var m_questionBackgroundView: UIView!
    @IBOutlet weak var m_answerLbl: UILabel!
    
    @IBOutlet weak var m_expandButton: UIButton!
    @IBOutlet weak var m_questionLbl: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setContent(data:ExpandedCell)
    {
        self.m_questionLbl.text=data.title
        
        if(data.expanded)
        {
//            var info = data.answer
//            info = info?.replacingOccurrences(of: "<ul><li>", with: "")
//            info = info?.replacingOccurrences(of: "<li>", with: "")
//            info = info?.replacingOccurrences(of: "</ul>", with: "\n")
//            info = info?.replacingOccurrences(of: "</b>  ", with: "\n")
//            info = info?.replacingOccurrences(of: "</li>", with: "\n")
//            info = info?.replacingOccurrences(of: "<ul><b>", with: "")
//            info = info?.replacingOccurrences(of: "<ol>", with: "")
//            info = info?.replacingOccurrences(of: "</ol>", with: "\n")
//            info = info?.replacingOccurrences(of: "<br />", with: "\n")
//            info = info?.replacingOccurrences(of: "<br>", with: "\n")
//            self.m_answerLbl.text = info
           
            var plainString = data.answer?.removeHTMLTags() ?? ""
            
            plainString = plainString.replacingOccurrences(of: "\\s{2,}", with: " ", options: .regularExpression)
            self.m_answerLbl.text = plainString
            
            m_expandButton.setImage(UIImage(named: "arrow_Reverse"), for: .normal)
            
            m_answerBackgroundView.isHidden=false
            
        }
        else
        {
            m_expandButton.setImage(UIImage(named: "arrow"), for: .normal)
            self.m_answerLbl.text = ""
            m_answerBackgroundView.isHidden=true
          
        }
    }
    
    //Used In Query
    func setContentQuery(data:ExpandedCell,expand:Bool)
       {
           self.m_questionLbl.text=data.title
           
           if(expand)
           {
               var info = data.answer
               info = info?.replacingOccurrences(of: "<ul><li>", with: "")
               info = info?.replacingOccurrences(of: "<li>", with: "")
               info = info?.replacingOccurrences(of: "</ul>", with: " ")
               info = info?.replacingOccurrences(of: "</b>  ", with: " ")
               info = info?.replacingOccurrences(of: "</li>", with: " ")
               info = info?.replacingOccurrences(of: "<ul><b>", with: "")
               
               print("Expand True = \n\(info)")

               self.m_answerLbl.text = info
               
               
               m_expandButton.setImage(UIImage(named: "arrow_Reverse"), for: .normal)
               
               m_answerBackgroundView.isHidden=false
               
           }
           else
           {
               print("Expand Failed....")

               m_expandButton.setImage(UIImage(named: "arrow"), for: .normal)
               self.m_answerLbl.text = ""
               m_answerBackgroundView.isHidden=true
               
           }
       }
    
    func setupFontUI(){
        m_questionLbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h15))
        m_questionLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_answerLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        m_answerLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
           
    }
}


extension String {
    func removeHTMLTags() -> String {
        // Replace &nbsp; with a space
        var stringWithoutNbsp = self.replacingOccurrences(of: "&nbsp;", with: " ")
        
        // Remove other HTML tags using regular expression
        stringWithoutNbsp = stringWithoutNbsp.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        
        return stringWithoutNbsp
    }
}
