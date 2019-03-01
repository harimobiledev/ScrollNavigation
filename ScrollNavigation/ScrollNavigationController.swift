//
//  CustomNavViewController.swift
//  PushPageView
//
//  Created by Hari Keerthipati on 04/02/19.
//  Copyright © 2019 Avantari Technologies. All rights reserved.
//

import UIKit

class ScrollNavigationController: UIViewController {
   
    var viewControllers:[BaseViewController] = [BaseViewController]()
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
        addInitialController()
    }
    
    func addScrollView()
    {
        scrollView = UIScrollView(frame: .zero)
        self.view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    }
    
    func addInitialController()
    {
        let viewController =  getViewController()
        viewController.navController = self
        viewController.view.frame = self.view.bounds
        viewController.view.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        viewControllers.append(viewController)
        scrollView.addSubview(viewController.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func pushTo(viewController: BaseViewController, animation: Bool) {
        add(viewController: viewController)
        scrollToPage(page: viewControllers.count - 1, animated: animation)
    }
    
    func add(viewController: BaseViewController)
    {
        let x = CGFloat(viewControllers.count) * self.view.frame.size.width
        viewController.navController = self
        viewController.view.frame = CGRect(x: x, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        viewControllers.append(viewController)
        scrollView.addSubview(viewController.view)
        updateScrollViewContentSize()
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollView.isUserInteractionEnabled = false
        self.scrollView.scrollRectToVisible(frame, animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollView.isUserInteractionEnabled = true
        }
    }
    
    func updateScrollViewContentSize()
    {
        self.scrollView.contentSize = CGSize(width: CGFloat(viewControllers.count) * self.view.frame.size.width, height: self.scrollView.frame.size.height)
    }
    
    func popViewController(animation: Bool)
    {
        removeViewControllers(from: viewControllers.count - 1)
        scrollToPage(page: 0, animated: animation)
    }
    
    func popToRootViewController(animation: Bool)
    {
        removeViewControllers(from: 1)
        scrollToPage(page: 0, animated: animation)
    }
    
    func getViewController() -> FirstViewController
    {
        let firstViewController = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as? FirstViewController
        return firstViewController!
    }
    
    func removeViewControllers(from fromIndex: Int)
    {
        for index in fromIndex..<viewControllers.count
        {
            let viewController = viewControllers[index]
            viewController.view.removeFromSuperview()
        }
        viewControllers.removeSubrange(fromIndex..<viewControllers.count)
        updateScrollViewContentSize()
    }
    
    func setScrollEnabled(enabled: Bool)
    {
        self.scrollView.isScrollEnabled = enabled
    }
    
    func getIndex(of viewController: BaseViewController) -> Int
    {
        let index = viewControllers.index(where: { (item) -> Bool in
            item == viewController // test if this is the item you're looking for
        })
        return index ?? 10000
    }
}

extension ScrollNavigationController: UIScrollViewDelegate
{
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if page < viewControllers.count - 1
        {
            removeViewControllers(from:page + 1)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        print("page===\(page)")
        if page < viewControllers.count - 1
        {
            removeViewControllers(from:page + 1)
        }
    }
}
