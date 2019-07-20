//
//  NavigationPage.swift
//  DDMvvm
//
//  Created by Dao Duy Duong on 9/26/18.
//

import UIKit
import RxSwift

open class NavigationPage: UINavigationController, ITransitionView, IDestroyable {
    
    public var animatorDelegate: AnimatorDelegate?
    
    /**
     Request to update status bar content color
     */
    public var statusBarStyle: UIStatusBarStyle = .lightContent {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    public var disposeBag: DisposeBag? = DisposeBag()
    
    public func destroy() {
        viewControllers.forEach { ($0 as? IDestroyable)?.destroy() }
    }
}

extension NavigationPage: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var animatorDelegate: AnimatorDelegate?
        switch operation {
        case .push: animatorDelegate = (toVC as? ITransitionView)?.animatorDelegate
        case .pop: animatorDelegate = (fromVC as? ITransitionView)?.animatorDelegate
        default: animatorDelegate = nil
        }
        
        animatorDelegate?.animator.isPresenting = operation == .push
        return animatorDelegate?.animator
    }
}
