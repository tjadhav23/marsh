//
//  ToolbarPickerView.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 18/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//


import Foundation
import UIKit

protocol ToolbarPickerViewDelegate: class {
    func didTapDone()
    func didTapCancel()
}

class ToolbarPickerView: UIPickerView {
    
    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: ToolbarPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = self.hexStringToUIColor(hex: hightlightColor)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.toolbar = toolBar
    }
    func hexStringToUIColor (hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#"))
        {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6)
        {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            
        )
    }
    
    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone()
    }
    
    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel()
    }
}

