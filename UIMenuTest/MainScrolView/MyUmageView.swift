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
            let resultFrame = self.convert(frame, to: self.window)
            
            currentViewController.presentSingleImageVC(image: showingImage, imageRect: resultFrame)
        }
        
    }

}
