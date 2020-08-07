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
        view.alpha = 0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSideMenu)))
        return view
    }()
    
    var widthConstraining: NSLayoutConstraint?
    let menuWidth:CGFloat = 200
    func setup(){
        
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            window.addSubview(blackView)
            window.addSubview(menu)
            blackView.translatesAutoresizingMaskIntoConstraints = false
            blackView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            blackView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            blackView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
            blackView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
            
            menu.translatesAutoresizingMaskIntoConstraints = false
            menu.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            menu.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            menu.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
            widthConstraining =  menu.trailingAnchor.constraint(equalTo: window.leadingAnchor)
            widthConstraining?.isActive = true
        }
    }
    let menu = Menu()
    func showSideMenu(){
        self.widthConstraining?.constant = self.menuWidth
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
            {
                
                self.blackView.alpha = 1
                if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                    window.layoutIfNeeded()
                }
                
        }
            , completion: nil)
    }
    
    
    
    
    @objc func dismissSideMenu() {
        widthConstraining?.constant = 0
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
            {
                self.blackView.alpha = 0
                if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                    window.layoutIfNeeded()
                }
                
                
        }
            , completion: nil)
        
    }
    
    
    
}

