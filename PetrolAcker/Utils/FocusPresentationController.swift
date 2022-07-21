//
//  FocusPresentationController.swift
//  tracco
//
//  Created by Ramadhan Kalih Sewu on 12/06/22.
//

import Foundation
import UIKit

/// presentation controller that automatically set the container view unfocus by darken the container view
class FocusPresentationController: UIPresentationController
{
    override func presentationTransitionWillBegin()
    {
        UIView.animate(withDuration: 0.3, delay: 0) { [unowned self] in
//            containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            containerView?.backgroundColor = .systemBackground.withAlphaComponent(0)
        }
    }
    
    override func dismissalTransitionWillBegin()
    {
        UIView.animate(withDuration: 0.3, delay: 0) { [unowned self] in
            containerView?.backgroundColor = UIColor.black.withAlphaComponent(0)
        }
    }
}
