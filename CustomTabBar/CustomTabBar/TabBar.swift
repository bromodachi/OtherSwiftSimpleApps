//
//  TabBar.swift
//  CustomTabBar
//
//  Created by c.uraga on 2016/11/16.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit
extension Int {
    func getCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}
protocol TabBarSourceDelegate {
    func sourceItems(tabarView : TabBar) -> [UITabBarItem]
}
protocol CustomTabBarDelegate {
    func didSelectViewController(tabBarView: TabBar, atIndex index: Int)
}

class TabBar: UIView {
    
    var selectedTabBarItemIndex: Int!
    var slideAnimationDuration: Double!
    var slideMaskDelay: Double!
    
    
    var dataSource: TabBarSourceDelegate!
    var delegate: CustomTabBarDelegate!
    
    var tabBarItems: [UITabBarItem]!
    var customTabBarItems: [CustomTabBarItem]!
    var tabBarButtons: [UIButton]!
    
    var initalTabBarItemIndex:Int!
    var tabBarItemWidth: CGFloat!
    
    var leftMask: UIView!
    var rightMask: UIView!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.brown
        initalTabBarItemIndex = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        tabBarItems = dataSource.sourceItems(tabarView: self)
        customTabBarItems = []
        tabBarButtons = []
        
        initalTabBarItemIndex = 1
        selectedTabBarItemIndex = initalTabBarItemIndex
        
        slideAnimationDuration = 0.6
        slideMaskDelay = slideAnimationDuration / 2
        
        let containers = createTabs()
        createTabBarItemSelectionOverlay(containers: containers)
        createTabBarItemSelectionOverlayMask(containers: containers)
        createTabBarItems(containers)
        
    }
    
    func createTabBarItemSelectionOverlay(containers: [CGRect]) {
        
        let overLayColors = [UIColor.red, UIColor.orange, UIColor.yellow]
        
        for index in 0..<tabBarItems.count {
            let container = containers[index]
            
            let view = UIView(frame: container)
            
            let selectedItemOverlay = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            selectedItemOverlay.backgroundColor = overLayColors[index]
            view.addSubview(selectedItemOverlay)
            addSubview(view)
        }
    
    }
    
    func createTabBarItemSelectionOverlayMask(containers: [CGRect] ){
        tabBarItemWidth = self.frame.width / tabBarItems.count.getCGFloat()
        let leftOverlaySlidingMultipler = initalTabBarItemIndex.getCGFloat() * tabBarItemWidth
        let rightOverlaySlidingMultipler = (initalTabBarItemIndex + 1).getCGFloat() * tabBarItemWidth
        
        
        leftMask = UIView(frame: CGRect(x: 0, y: 0, width: leftOverlaySlidingMultipler, height: self.frame.height))
        leftMask.backgroundColor = UIColor.brown
    
        rightMask = UIView(frame: CGRect(x: rightOverlaySlidingMultipler, y: 0, width: tabBarItemWidth * CGFloat(tabBarItems.count - 1), height: self.frame.height))
        
        rightMask.backgroundColor = UIColor.brown
        
        addSubview(leftMask)
        
        addSubview(rightMask)
        
    }
    
    func createTabBarItems(_ containers: [CGRect]){
        var index = 0
        for item in tabBarItems {
            let container = containers[index]
            
            let customTabItemTemp = CustomTabBarItem(frame: container)
            customTabItemTemp.setup(item: item)
            
            addSubview(customTabItemTemp)
            customTabBarItems.append(customTabItemTemp)
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: container.width, height: container.height))
            button.addTarget(self, action: #selector(barItemTapped(sender:)), for: .touchUpInside)
            
            customTabItemTemp.addSubview(button)
            tabBarButtons.append(button)
            
            index += 1
            
        }
        
        self.customTabBarItems[initalTabBarItemIndex].iconView.tintColor = UIColor.blue
    }
    
    func animateTabBarSelection(from: Int, to: Int){
        let overlaySlidingMultipler = CGFloat(to - from) * tabBarItemWidth
        
        let leftMaskDelay: Double!
        let rightMaskDelay: Double!
        
        if overlaySlidingMultipler > 0 {
            leftMaskDelay = slideMaskDelay
            rightMaskDelay = 0
        }
        
        else {
            leftMaskDelay = 0
            rightMaskDelay = slideMaskDelay
        }
        
        UIView.animate(withDuration: slideAnimationDuration - leftMaskDelay, delay: leftMaskDelay, options: .curveEaseInOut, animations: {
            self.leftMask.frame.size.width += overlaySlidingMultipler
        }, completion: nil)
        UIView.animate(withDuration: slideAnimationDuration - rightMaskDelay, delay: rightMaskDelay, options: .curveEaseInOut, animations: {
            self.rightMask.frame.origin.x += overlaySlidingMultipler
            self.rightMask.frame.size.width += -overlaySlidingMultipler
            self.customTabBarItems[from].iconView.tintColor = UIColor.black
            self.customTabBarItems[to].iconView.tintColor = UIColor.blue
        }, completion: nil)
    }
    
    
    func createTabs() -> [CGRect] {
        var containerArray = [CGRect]()
        for index in 0..<tabBarItems.count {
            let tabBarCainer = createTabBarContainer(index: index)
            containerArray.append(tabBarCainer)
            
        }
        return containerArray
    }
    
    func createTabBarContainer(index: Int) -> CGRect {
        let tabBarContainerWidth = self.frame.width / tabBarItems.count.getCGFloat()
        return CGRect(x: tabBarContainerWidth * index.getCGFloat() , y: 0, width: tabBarContainerWidth, height: frame.height)
        
    }
    
    func barItemTapped(sender : UIButton) {
        let index = tabBarButtons.index(of: sender)!
        print("tapped \(index)")
        animateTabBarSelection(from: selectedTabBarItemIndex, to: index)
        selectedTabBarItemIndex = index
        delegate.didSelectViewController(tabBarView: self, atIndex: index)
    }

}
