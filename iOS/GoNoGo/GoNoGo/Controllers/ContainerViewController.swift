//
//  ContainerViewController.swift
//  GoNoGo
//
//  Created by Seth Kurkowski on 4/26/19.
//  Copyright © 2019 Seth Kurkowski. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController
{
    enum MenuState
    {
        case showing
        case notShowing
    }
    var currentMenuState: MenuState = .notShowing {
        didSet
        {
            if currentMenuState == .notShowing
            {
                self.view.layer.shadowOpacity = 0.0
            }
            else if currentMenuState == .showing
            {
                self.view.layer.shadowOpacity = 0.8
            }
        }
    }
    
    var sideMenuViewController:  SideMenuViewController?
    var homeViewController:      HomeViewController!
    var locationsViewController: LocationsViewController?
    var checklistViewController: ChecklistViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        homeViewController          = UIStoryboard.homeViewController()
        homeViewController.delegate = self
        view.addSubview(homeViewController.view)
        addChild(homeViewController)
        homeViewController.didMove(toParent: self)
    }
}

private extension UIStoryboard
{
    static func mainStoryboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    static func homeViewController() -> HomeViewController?
    {
        return mainStoryboard().instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    }
}
