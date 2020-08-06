//
//  SideMenu.swift
//  Chatctron
//
//  Created by Hanlin Chen on 8/6/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit
class Menu : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMenu()
    }
    
    func setupMenu(){
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
class SideMenu {
    
    
    lazy var blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSideMenu)))
        return view
    }()
    
    let menu = Menu()
    func showSideMenu(){
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            window.addSubview(blackView)
            window.addSubview(menu)
            blackView.translatesAutoresizingMaskIntoConstraints = false
            blackView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            blackView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            blackView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
            blackView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
            let menuWidth = window.frame.size.width * 0.5
            menu.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: window.frame.size.height)
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
                {
                    self.blackView.alpha = 1
                    self.menu.frame = CGRect(x: 0, y: 0, width: menuWidth, height: window.frame.size.height)
            }
                , completion: nil)
        }
        
        
    }
    
    @objc func dismissSideMenu() {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
            {
                self.blackView.alpha = 0
                self.menu.frame = CGRect(x: -self.menu.frame.width, y: 0, width: self.menu.frame.width, height: self.menu.frame.height)
                
        }
            , completion: nil)
        
    }
    
    
    
}

