//
//  OtherInsuranceVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 18/09/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import SDWebImage

class OtherInsuranceTVC: UITableViewController {

    @IBOutlet weak var gifLoaderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        displayGIF()
        
        gifLoaderView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(gifViewTapped(_:)))
        gifLoaderView.addGestureRecognizer(tapGesture)
        
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)

    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
        //        tabBarController!.selectedIndex = 2
    }

    
    @objc func gifViewTapped(_ sender : UITapGestureRecognizer) {
        let url = URL(string: "https://elephant.in")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    private func displayGIF() {
        DispatchQueue.main.async {
//            let jeremyGif = UIImage.gifImageWithName("FinalMobileBanner")
//            let imageView1 = UIImageView(image: jeremyGif)
//            let jeremyGif = UIImage.gif(name: "FinalMobileBanner")
//
//            // A UIImageView with async loading
//            let imageView1 = UIImageView()
//            imageView1.loadGif(name: "FinalMobileBanner")
            
            let imageView1 = SDAnimatedImageView()
            let animatedImage = SDAnimatedImage(named: "FinalMobileBanner.gif")
            imageView1.image = animatedImage
            imageView1.frame = CGRect(x: 0, y: 0, width: self.gifLoaderView.frame.size.width, height: self.gifLoaderView.frame.size.height)
            //imageView1.contentMode = .scaleAspectFill
            self.gifLoaderView.addSubview(imageView1)
        }
    }
  
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden=false
        navigationItem.leftBarButtonItem=getBackButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        
        
        self.title = "Retail Insurance"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
