//
// RedTabBar.swift
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
import FloatingTabBarController

class GrayTabBar: FloatingTabBar {
    
    private weak var stackView: UIStackView!
    private var shapeLayer: CAShapeLayer!
    private var lastFrame: CGRect
    var accentColor = UIColor(red: 247/255, green: 39/255, blue: 23/255, alpha: 1)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        self.lastFrame = frame
        super.init(frame: frame)
                
        let stackView = UIStackView(frame: bounds)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 58).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 32).isActive = true
        self.stackView = stackView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.scrollBarIndicatorOffset = 34 - safeAreaInsets.bottom
        if frame != lastFrame {
            shapeLayer?.removeFromSuperlayer()
            shapeLayer = nil
        }
        
        if shapeLayer == nil {
            setupShape()
        }
    }
    
    override func reload() {
        
        stackView.arrangedSubviews.forEach { v in
            v.removeFromSuperview()
        }
        
        guard let viewControllers = floatingTabBarController?.viewControllers else {
            return
        }
        let items = (viewControllers).map({ $0.tabBarItem! })
        
        guard items.count > 0 else {
            return
        }
        
        let selectedIndex = floatingTabBarController?.selectedIndex
        
        for (index, item) in items.enumerated() {
            let v = buttonForItem(item)
            v.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
            v.tag = index
            self.stackView.addArrangedSubview(v)
            configure(v, isSelected: index == selectedIndex)
        }
    }
    
    @objc
    private func handleTap(_ sender: UIButton) {
        for (_, view) in stackView.arrangedSubviews.enumerated() {
            guard let button = view as? UIButton else {
                continue
            }
            configure(button, isSelected: button == sender)
        }
        
        floatingTabBarController?.selectedIndex = sender.tag
    }
    
    func buttonForItem(_ item: UITabBarItem) -> UIButton {
        let result = CustomButton(type: .custom)
        result.setTitle(item.title, for: .normal)
        result.setTitleColor(UIColor.gray, for: .normal)
        result.setTitleColor(UIColor.red, for: .selected)
        result.setImage(item.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        result.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        return result
    }
    
    private func configure(_ button: UIButton, isSelected: Bool) {
        button.isSelected = isSelected
        if isSelected {
            button.tintColor = UIColor.red
        } else {
            button.tintColor = UIColor.gray
        }
    }
    
    private func setupShape() {
        
        // Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        
        // The Bezier path that we made needs to be converted to
        // a CGPath before it can be used on a layer.
        shapeLayer.path = createBezierPath().cgPath
        
        // apply other properties related to the path
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.90).cgColor
        shapeLayer.fillColor = UIColor.white.withAlphaComponent(0.90).cgColor
        shapeLayer.lineWidth = 1.0
        
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowPath = shapeLayer.path
        shapeLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shapeLayer.shadowOpacity = 0.6
        shapeLayer.shadowRadius = 8
        
        // add the new layer to our custom view
        layer.insertSublayer(shapeLayer, at: 0)
        self.shapeLayer = shapeLayer
    }
    
    private func createBezierPath() -> UIBezierPath {
        
        // create a new path
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: (bounds.width) - 20, y: bounds.height * 0.3))
        path.addLine(to: CGPoint(x: (bounds.width / 2), y: 0))
        path.addLine(to: CGPoint(x: 20, y: bounds.height * 0.3))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        
        path.close() // draws the final line to close the path
        
        return path
    }}

fileprivate final class CustomButton: UIButton {
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let superRect = super.titleRect(forContentRect: contentRect)
        return CGRect(
            x: 0,
            y: contentRect.height - superRect.height - 10,
            width: contentRect.width,
            height: superRect.height
        )
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let superRect = super.imageRect(forContentRect: contentRect)
        return CGRect(
            x: contentRect.width / 2 - superRect.width / 2,
            y: (contentRect.height - titleRect(forContentRect: contentRect).height) / 2 - superRect.height / 2,
            width: superRect.width,
            height: superRect.height
        )
    }
    
    override var intrinsicContentSize: CGSize {
        _ = super.intrinsicContentSize
        guard let image = imageView?.image else { return super.intrinsicContentSize }
        let size = titleLabel?.sizeThatFits(contentRect(forBounds: bounds).size) ?? .zero
        let spacing: CGFloat = 12
        return CGSize(width: max(size.width, image.size.width), height: image.size.height + size.height + spacing)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        titleLabel?.textAlignment = .center
    }
}
