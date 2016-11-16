//
//  ViewController.swift
//  CustomTabBar
//
//  Created by c.uraga on 2016/11/16.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit

class ViewController: UITabBarController, TabBarSourceDelegate, CustomTabBarDelegate, UITabBarControllerDelegate {
    
    private var previousInt: Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        delegate = self
        
        let tabBar = TabBar(frame: self.tabBar.frame)
        self.selectedIndex = 1
        previousInt = -1
//        tabBar.backgroundColor = UIColor.blue
        tabBar.dataSource = self
        tabBar.delegate = self
        tabBar.setup()
        view.addSubview(tabBar)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sourceItems(tabarView: TabBar) -> [UITabBarItem] {
        
        return self.tabBar.items!
    }
    
    func didSelectViewController(tabBarView: TabBar, atIndex index: Int) {
        previousInt = index
        self.selectedIndex = index
    }

    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimation(leftOrRight: self.selectedIndex - previousInt)
    }

}

