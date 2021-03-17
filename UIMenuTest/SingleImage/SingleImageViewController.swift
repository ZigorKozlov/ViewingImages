//
//  SingleImageViewController.swift
//  UIMenuTest
//
//  Created by Игорь Козлов on 15.03.2021.
//

import UIKit

class SingleImageViewController: UIViewController {
    lazy var backButton: UIButton = {
        let button = UIButton(type: .close, primaryAction: UIAction(handler: {
            [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }))
        
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = button.layer.frame.height 
        button.clipsToBounds = false
        button.sizeToFit()
        button.frame.origin = CGPoint(x: 20, y: 40)
        
        return button
    }()

    var imageScrollView: ImageScrolView!
    var image: UIImage!
    
    fileprivate func configurateScrolView() {
        imageScrollView = ImageScrolView(frame: view.bounds, rootViewController: self as UIViewController)
        view.addSubview(imageScrollView)
        view.addSubview(backButton)
        setupImageScrollView()
        imageScrollView.set(image: image)
    }
    lazy var item: DispatchWorkItem = {
        return DispatchWorkItem {
            self.handleShowOrHideButtons(choice: .hide)

        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        configurateScrolView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: item)

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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageScrollView.configurateFor(imagesize: image.size)
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
            item.cancel()
            UIButton.animate(withDuration: 0.3) {
                self.backButton.alpha = 1.0
                
            }
            backButton.isUserInteractionEnabled = true

            updateStatusBarAppearance(hidden: false)
            return
        } else if choice == .hide {
            item.cancel()
            //Hide buttons and status bar
            UIButton.animate(withDuration: 0.3) {
                self.backButton.alpha = 0.0
            }
            backButton.isUserInteractionEnabled = false
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
