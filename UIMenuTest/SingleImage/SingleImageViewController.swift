//
//  SingleImageViewController.swift
//  UIMenuTest
//
//  Created by Игорь Козлов on 15.03.2021.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var transpatancy:CGFloat = 1.0
    var gestureOffset: CGFloat = 0.0
    var imageScrollView: ImageScrolView!
    var image: UIImage!
    
    //For conform StatusBarAnimationViewController protocol
    var statusBarShuldBeHidden: Bool = false
    var statusBarAnimationStyle: UIStatusBarAnimation = .slide
    
    //MARK: - Lazy Propertyes
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        
        return panGestureRecognizer
    }()
    
    @objc func panGestureHandler(gesture: UIPanGestureRecognizer ) {
        
        
        switch gesture.state {
        case .began:
            gestureOffset = gesture.translation(in: view).y
            print("gestureOffset = \(gestureOffset)")
        case .changed:
            print("changed: = \(gesture.translation(in: view).y)")
            imageScrollView.imageZoomView?.center.y += (gesture.translation(in: view).y)
           
            view.isOpaque = false
            transpatancy -= abs( gesture.translation(in: view).y / 100 )
                                    
            view.backgroundColor = UIColor(displayP3Red: 0.95, green: 0.95, blue: 0.95, alpha: transpatancy)
            
            gesture.setTranslation(CGPoint.zero, in: view) // ПО сути обнуляем смещение что бы не накапливалось))
        case .ended:
            print("ended")
            imageScrollView.setCenterImage(animated: true)
            transpatancy = 1.0
            UIView.animate(withDuration: 0.3) {
                [weak self] in
                self?.view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0)
            }
            
            //imageScrollView.layoutIfNeeded()
            
        case .cancelled:
            print("cancelled")
            
        default:
            print("default")
        }
        
        
        //dismiss(animated: true, completion: nil)
    }
    
    
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
    
    lazy var itemForHideButton: DispatchWorkItem = {
        return DispatchWorkItem {
            self.handleShowOrHideButtons(choice: .hide)
        }
    }()

    //MARK: - Live cycle UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        configurateScrolView()
        view.addGestureRecognizer(panGestureRecognizer)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: itemForHideButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageScrollView.configurateFor(imagesize: image.size)
    }

}



//MARK: - Configurate ScrollSimgleImageView
extension SingleImageViewController {
    private func configurateScrolView() {
        imageScrollView = ImageScrolView(frame: view.bounds, rootViewController: self as UIViewController)
        view.addSubview(imageScrollView)
        view.addSubview(backButton)
        setupImageScrollViewConstraints()
        imageScrollView.set(image: image)
    }
    
    private func setupImageScrollViewConstraints() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

//MARK: - SELECTORS
extension SingleImageViewController {
    @objc func closeVC(sender: Any?){
        if statusBarShuldBeHidden {
            updateStatusBarAppearance(hidden: false)
        }
        navigationController?.popViewController(animated: true)
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
            itemForHideButton.cancel()
            UIButton.animate(withDuration: 0.3) {
                self.backButton.alpha = 1.0
                
            }
            backButton.isUserInteractionEnabled = true

            updateStatusBarAppearance(hidden: false)
            return
        } else if choice == .hide {
            itemForHideButton.cancel()
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

//MARK: - For hide StatusBar
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


