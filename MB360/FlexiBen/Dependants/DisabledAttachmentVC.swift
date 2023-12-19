//
//  DisabledAttachmentVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 03/04/21.
//  Copyright © 2021 Semantic. All rights reserved.
//

import UIKit

class DisabledAttachmentVC: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    var attachmentUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        webView.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        webView.layer.borderWidth = 1.0
        webView.layer.cornerRadius = 12.0
        
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.scrollView.isScrollEnabled = false
        webView.loadRequest(URLRequest(url:URL(string: attachmentUrl)!))
    }
    
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//        webView.frame.size.height = 1
//        webView.frame.size = webView.sizeThatFits(CGRect.zero)
//    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
