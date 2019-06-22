//
//  SideMenuDelegate.swift
//  GoNoGo
//
//  Created by Seth Kurkowski on 4/26/19.
//  Copyright © 2019 Seth Kurkowski. All rights reserved.
//

import Foundation

extension HomeViewController: SideMenuViewControllerDelegate
{
    func didSelect(_ item: Int)
    {
        print(item)
    }
}
