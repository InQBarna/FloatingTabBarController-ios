//
// FloatingTabBarController.swift
//
// Copyright (c) 2021 InQBarna Kenkyuu Jo (http://inqbarna.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

public class FloatingTabBarController: UITabBarController {

    public var floatingTabBar: FloatingTabBar? {
        didSet {
            if let oldValue = oldValue {
                oldValue.floatingTabBarController = nil
                oldValue.removeFromSuperview()
            }

            if let floatingTabBar = floatingTabBar {
                floatingTabBar.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(floatingTabBar)
                floatingTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                floatingTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
                floatingTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
                floatingTabBar.floatingTabBarController = self
                floatingTabBar.reload()
            }
        }
    }

    public override var viewControllers: [UIViewController]? {
        didSet {
            floatingTabBar?.reload()
        }
    }

    public override var selectedIndex: Int {
        didSet {
            if
                selectedIndex == oldValue,
                let nc = selectedViewController as? UINavigationController
            {
                nc.popToRootViewController(animated: true)
            }
        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard
            #available(iOS 11.0, *),
            let floatingTabBar = floatingTabBar
        else {
            return
        }

        viewControllers?.forEach({ vc in
            var insets = self.view.safeAreaInsets
            insets.top = 0
            insets.bottom = view.frame.height - floatingTabBar.frame.origin.y - view.safeAreaInsets.bottom
            vc.additionalSafeAreaInsets = insets
        })
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        floatingTabBar?.reload()
    }

    public func adjustScrollIndicator(_ scrollView: UIScrollView) {
        guard
            #available(iOS 11.0, *),
            let floatingTabBar = floatingTabBar
        else {
            return
        }

        let x = floatingTabBar.frame.height - view.safeAreaInsets.bottom - floatingTabBar.scrollBarIndicatorOffset
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -x, right: 0)
    }
}

public extension UIViewController {
    var floatingTabBarController: FloatingTabBarController? {
        guard let parent = parent else {
            return nil
        }

        guard let result = parent as? FloatingTabBarController else {
            return parent.floatingTabBarController
        }

        return result
    }
}