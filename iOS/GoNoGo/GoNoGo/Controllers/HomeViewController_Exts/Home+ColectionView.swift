//
//  CollectionViewMethods.swift
//  GoNoGo
//
//  Created by Seth Kurkowski on 4/26/19.
//  Copyright © 2019 Seth Kurkowski. All rights reserved.
//

import UIKit

extension HomeViewController
{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return launches.getAllLaunches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingLaunchCell.reuseIdentifier, for: indexPath) as? UpcomingLaunchCell else { return UICollectionViewCell() }
        cell.launch = launches.getAllLaunches[indexPath.item]
        if cell.launch?.name == "SpaceX"
        {
            if (cell.launch?.rocket.contains("Falcon 9"))!
            {
                cell.landing1Lbl.isHidden = false
            }
            else
            {
                cell.landing1Lbl.isHidden = false
                cell.landing2Lbl.isHidden = false
            }
        }
        else
        {
            cell.landing1Lbl.isHidden = true
            cell.landing2Lbl.isHidden = true
        }
        return cell
    }
}
