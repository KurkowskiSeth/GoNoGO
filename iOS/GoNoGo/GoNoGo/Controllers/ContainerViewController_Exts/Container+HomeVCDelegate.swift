//
//  Container+HomeViewControllerDelegate.swift
//  GoNoGo
//
//  Created by Seth Kurkowski on 4/28/19.
//  Copyright © 2019 Seth Kurkowski. All rights reserved.
//

import Foundation

extension ContainerViewController: HomeViewControllerDelegate
{
    func toggleSideMenu()
    {
        let shouldShow = currentMenuState != .showing
        
        homeViewController.collectionView.isUserInteractionEnabled = !shouldShow
        
        if shouldShow
        {
            addSideMenu()
        }
        animateCenterView(shouldShow)
    }
}
