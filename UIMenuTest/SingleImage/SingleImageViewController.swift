//
//  SingleImageViewController.swift
//  UIMenuTest
//
//  Created by Игорь Козлов on 15.03.2021.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var inputImageRect: CGRect!
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
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .close, primaryAction: UIAction(handler: {
            [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }))
        
        button.layer.cornerRadius = button.layer.frame.height 
        button.clipsToBounds = false
        button.sizeToFit()
        button.frame.origin = CGPoint(x: 20, y: 40)
        
        return button
    }()
    
    lazy var itemForHideButton: DispatchWorkItem = {
        return DispatchWorkItem {
            [weak self] in
            self?.handleShowOrHideButtons(choice: .hide)
        }
    }()

    //MARK: - Live cycle UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setColorsWith(alpha: 1.0, animated: false)
        
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
    
    @objc func panGestureHandler(gesture: UIPanGestureRecognizer ) {
        
        
        switch gesture.state {
        case .began:
            gestureOffset = 0.0
            transpatancy = 1.0
            handleShowOrHideButtons(choice: .hide)
        case .changed:
            changedHandler(gesture) // ПО сути обнуляем смещение что бы не накапливалось))
        
        case .ended:
            if abs( gestureOffset ) > 60 {
                animateCloce()
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300))  {
                    [weak self] in
                    self?.dismiss(animated: false, completion: nil)
                }
                //dismiss(animated: true, completion: nil)
            } else {
                
                imageScrollView.setCenterImage(animated: true)
                transpatancy = 1.0
                
                setColorsWith(alpha: 1.0, animated: true)
 
            }
            
        case .cancelled:
            imageScrollView.setCenterImage(animated: true)
            transpatancy = 1.0
            
            setColorsWith(alpha: 1.0, animated: true)
            
        default:
            print("default")
        }
        //dismiss(animated: true, completion: nil)
    }
    
    private func changedHandler(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view).y
        
        imageScrollView.imageZoomView?.center.y += translation //move image
        
        if gestureOffset > -30 && gestureOffset < 30 {
            transpatancy = 1.0
        } else {
            //Обработать одновременно и gestureOffset и translation
            if ((gestureOffset > 0 && translation > 0) || (gestureOffset < 0 && translation < 0)) {
                transpatancy -= abs( translation / 100)
            } else if (gestureOffset > 0 && translation < 0) || (gestureOffset < 0 && translation > 0) {
                transpatancy += abs( translation / 100)
            }
        }
        
        setColorsWith(alpha: transpatancy, animated: false)
        gestureOffset += translation //global offset
        
        
        gesture.setTranslation(CGPoint.zero, in: view)
    }
    
    private func setColorsWith(alpha: CGFloat, animated: Bool, duration: TimeInterval = 0.3) {
        var resultAlpha: CGFloat = 0.0
        if alpha > 1 {
            resultAlpha = 1.0
        } else if alpha < 0 {
            resultAlpha = 0.0
        } else {
            resultAlpha = alpha
        }
        
        let darkColorV = UIColor(displayP3Red: 0.05, green: 0.05, blue: 0.05, alpha: resultAlpha)
        let lightColorV = UIColor(displayP3Red: 0.96, green: 0.96, blue: 0.96, alpha: resultAlpha)
        
        
        let darkColor = UIColor(displayP3Red: 0.4, green: 0.4, blue: 0.4, alpha: resultAlpha)
        let lightColor = UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: resultAlpha)
        
        if animated {
            UIView.animate(withDuration: duration) {
                [weak self] in
                self?.view.backgroundColor = UIColor.myColorFor(light: lightColorV, dark: darkColorV)
                self?.backButton.backgroundColor = UIColor.myColorFor(light: lightColor, dark: darkColor)
                

            }
        } else {
            view.backgroundColor = UIColor.myColorFor(light: lightColorV, dark: darkColorV)
            backButton.backgroundColor = UIColor.myColorFor(light: lightColor, dark: darkColor)
            
         
        }

    }
    
    func animateCloce() {
        setColorsWith(alpha: 0.0, animated: true, duration: 0.3)
        UIView.animate(withDuration: 0.3) {
            [weak self] in
            self?.backButton.alpha = 0.0
                        
            self?.imageScrollView.imageZoomView?.frame.origin.x = self?.inputImageRect.origin.x ?? 0.0
            self?.imageScrollView.imageZoomView?.frame.origin.y = self?.inputImageRect.origin.y ?? 0.0
            

        }
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


