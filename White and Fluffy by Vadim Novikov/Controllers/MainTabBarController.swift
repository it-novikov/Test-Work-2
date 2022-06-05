//
//  MainTabBarController.swift
//  White and Fluffy by Vadim Novikov
//
//  Created by Vadim Novikov on 05.06.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let networkService = NetworkServiceImplementation()
    lazy var networkDataFetcher = NetworkDataFetcher(networkService: networkService)

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    
    func setTabBar() {
        let photoesViewController = createNavigationController(vc: PhotoesViewController(networkDataFetcher: networkDataFetcher), itemName: "Photoes", itemImage: "photo.fill")
        let favouritesViewController = createNavigationController(vc: FavouritesViewController(), itemName: "Favourites", itemImage: "star.square.fill")
        
        viewControllers = [photoesViewController, favouritesViewController]
    }

    func createNavigationController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: itemImage), tag: 0)
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        return navController
    }
    
}
