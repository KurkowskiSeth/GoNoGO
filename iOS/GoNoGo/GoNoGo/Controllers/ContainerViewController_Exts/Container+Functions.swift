//
//  Functions.swift
//  GoNoGo
//
//  Created by Seth Kurkowski on 4/26/19.
//  Copyright © 2019 Seth Kurkowski. All rights reserved.
//

import UIKit

private let centerPanelExpandOffset: CGFloat = 90

extension ContainerViewController
{
    func addSideMenu()
    {
        guard sideMenuViewController == nil else { return }
        
        if let vc = UIStoryboard.sideMenuViewController()
        {
            addSideMenuViewController(vc)
            vc.delegate = self
            sideMenuViewController = vc
        }
    }
    
    private func addSideMenuViewController(_ sideMenuViewController: SideMenuViewController)
    {
        view.insertSubview(sideMenuViewController.view, at: 0)
        
        addChild(sideMenuViewController)
        sideMenuViewController.didMove(toParent: self)
    }
    
    func animateCenterView(_ shouldShow: Bool)
    {
        if shouldShow
        {
            currentMenuState = .showing
            animateCenterPanelXPosition(targetPosition: self.view.frame.width - centerPanelExpandOffset)
        }
        else
        {
            animateCenterPanelXPosition(targetPosition: 0) { (_) in
                self.currentMenuState       = .notShowing
                self.sideMenuViewController?.view.removeFromSuperview()
                self.sideMenuViewController = nil
            }
        }
    }
    
    private func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil)
    {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.0,
            options: .curveEaseOut,
            animations: {
                self.homeViewController.view.frame.origin.x = targetPosition
        },
            completion: completion)
    }
}

//  MARK: Storyboard Extension
private extension UIStoryboard
{
    static func mainStoryboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    static func sideMenuViewController() -> SideMenuViewController?
    {
        return mainStoryboard().instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
    }
}
