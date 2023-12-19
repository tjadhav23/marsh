//
//  protocols.swift
//  MyBenefits360
//
//  Created by home on 06/12/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation


protocol MoveToPreviousVCProtocol {
    func moveToPreviousVC()
}

protocol tableCellDelegate{
    func passIndex(type : String,index: Int)
}


//send control PageVC to CollectionVC
protocol PageChangedProtocol { //For PageControl
    func pageChanged(index:Int) //swipe pages
    func animateCollectionView(index:Int) //when user scroll then hide/animate collectionview
}

//send control TableVC to PageVC
protocol HideCollectionViewProtocol { //For Other ViewControllers
func scrolled(index:Int)
func show(index:Int)
}

protocol MoveCardToNextProtocol {
    func moveToNextCard()
}

protocol refreshAfterDismiss {
    func refreshData(_ type: String)
}

protocol DashboardCollectionViewProtocol {
    func changeDashboardTapped(dashboard:Int)
}

