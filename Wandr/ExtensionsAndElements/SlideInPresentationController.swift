//
//  SlideInPresentationController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/10/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class SlideInPresentationController: UIPresentationController {
    
    let spacingForDismissView: CGFloat = 10
    
    var presentedControllerHeight: CGFloat!
    
    lazy var distanceToPresentationController = (containerView!.frame.height) - self.presentedControllerHeight
    
    private var dismissView: UIView!
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    let topSafeArea = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
    
    let bottomSafeArea = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    
    private var dimmingView: UIView!
    
    private var direction: PresentationDirection
    
    
    override var frameOfPresentedViewInContainerView: CGRect {
        //1
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        
        //2
        switch direction {
        case .right:
            frame.origin.x = containerView!.frame.width*(1.0/3.0)
        case .bottom:
            frame.origin.y = self.distanceToPresentationController
        default:
            frame.origin = .zero
        }
        return frame
    }

    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         direction: PresentationDirection, height: CGFloat) {
        
        self.presentedControllerHeight = height
        
        self.direction = direction
        
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        setupDimmingView()
        setupDismissIndicator()
    }
    
    override func presentationTransitionWillBegin() {
        guard let dimmingView = dimmingView else {
            return
        }
        
        guard let dismissView = dismissView else {
            return
        }
        
        // 1
        containerView?.insertSubview(dimmingView, at: 0)
        
        containerView?.addSubview(dismissView)
        
        // 2
        dimmingView.anchor(top: containerView?.topAnchor, bottom: containerView?.bottomAnchor, leading: containerView?.leadingAnchor, trailing: containerView?.trailingAnchor)
        
        dismissView.topAnchor.constraint(equalTo: dimmingView.topAnchor, constant: distanceToPresentationController - spacingForDismissView).isActive = true
        dismissView.centerXAnchor.constraint(equalTo: self.containerView!.centerXAnchor).isActive = true
        
        //3
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            dismissView.removeFromSuperview()
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
            self.dismissView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        switch direction {
        case .left, .right:
            return CGSize(width: parentSize.width*(5.0/6.0), height: parentSize.height)
        case .bottom, .top:
            return CGSize(width: parentSize.width, height: presentedControllerHeight)
        }
    }
}

private extension SlideInPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        let recognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(panGestureRecognizerHandler(_:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    func setupDismissIndicator() {
        dismissView = UIView()
        dismissView.translatesAutoresizingMaskIntoConstraints = false
        dismissView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dismissView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        dismissView.layer.cornerRadius = 2.5
        dismissView.layer.masksToBounds = true
        dismissView.backgroundColor = UIColor.white
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.presentedViewController.view.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.presentedViewController.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y + distanceToPresentationController, width: self.presentedViewController.view.frame.size.width, height: self.presentedViewController.view.frame.size.height)
                self.dismissView.frame = CGRect(x: (containerView!.frame.width / 2) - 50, y: touchPoint.y - initialTouchPoint.y + distanceToPresentationController - spacingForDismissView, width: 100, height: 5)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.presentedViewController.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.presentedViewController.view.frame = CGRect(x: 0, y: self.distanceToPresentationController, width: self.presentedViewController.view.frame.size.width, height: self.presentedViewController.view.frame.size.height)
                    self.dismissView.frame = CGRect(x: (self.containerView!.frame.width / 2) - 50, y: self.distanceToPresentationController - self.spacingForDismissView, width: 100, height: 5)
                })
            }
        }
    }
}

