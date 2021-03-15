//
//  MyUmageView.swift
//  UIMenuTest
//
//  Created by Игорь Козлов on 15.03.2021.
//

import UIKit

class MyUmageView: UIImageView {

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        //open the picture for viewe
        
        if case let navigation as UINavigationController = UIApplication.shared.windows.first?.rootViewController,
           case let currentViewController as AlbumViewController = navigation.viewControllers.first {
            guard let showingImage = self.image else { return }
            currentViewController.presentSingleImageVC(image: showingImage)
        }
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
