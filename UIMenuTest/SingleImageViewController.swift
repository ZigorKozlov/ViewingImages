//
//  SingleImageViewController.swift
//  UIMenuTest
//
//  Created by Игорь Козлов on 15.03.2021.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    //let navigationBar = UINavigationBar()
    var imageScrollView: ImageScrolView!
    var image: UIImage!
    
    fileprivate func configurateScrolView() {
        imageScrollView = ImageScrolView(frame: view.bounds)
        view.addSubview(imageScrollView)
        
        setupImageScrollView()
        imageScrollView.set(image: image)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.updateStatusBarAppearance(hidden: true)
        }
        view.backgroundColor = .white
        configurateNavigationBar()
        configurateScrolView()
        navigationController?.navigationBar.isHidden = true
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeVC(sender:)))
        //UINavigationBarAppearance
    }
    
    
    //For conform StatusBarAnimationViewController protocol
    var statusBarShuldBeHidden: Bool = false
    var statusBarAnimationStyle: UIStatusBarAnimation = .slide
    
}
extension SingleImageViewController {
    @objc func closeVC(sender: Any?){
        if statusBarShuldBeHidden {
            updateStatusBarAppearance(hidden: false)
        }
        navigationController?.popViewController(animated: true)
    }
}
extension SingleImageViewController {
    func configurateNavigationBar() {
        //navigationBar.backgroundColor = UIColor(displayP3Red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        //navigationBar.items?.append(UINavigationItem())
        //navigationBar.i
    }
    
    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

    }
}

extension SingleImageViewController {
    enum ButtonShowOrHideChoice {
        case show
        case hide
    }
    
    func handleShowOrHideButtons(choice: ButtonShowOrHideChoice) {
        if choice == .show {
            //Show buttons and status bar
            updateStatusBarAppearance(hidden: false)
            return
        } else if choice == .hide {
            //Hide buttons and status bar
            updateStatusBarAppearance(hidden: true )
            return
        }
    }
    
}


//MARK: - Status bar
protocol StatusBarAnimationViewController: class {
    var statusBarShuldBeHidden: Bool { get set }
    var statusBarAnimationStyle: UIStatusBarAnimation { get set }
}

extension StatusBarAnimationViewController where Self: UIViewController {
    func updateStatusBarAppearance(hidden: Bool, withDuration duration: Double = 0.3, complition: ((Bool)-> Void)? = nil ) {
        statusBarShuldBeHidden = hidden
        
        UIView.animate(withDuration: duration, animations: {
            [weak self] in
            self?.setNeedsStatusBarAppearanceUpdate()
        }, completion: complition)

    }
}


extension SingleImageViewController: StatusBarAnimationViewController {
    override var prefersStatusBarHidden: Bool {
        return statusBarShuldBeHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return statusBarAnimationStyle
    }
    
}
