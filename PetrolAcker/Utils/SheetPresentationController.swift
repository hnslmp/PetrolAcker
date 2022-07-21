//
//  SheetPresentationController.swift
//  tracco
//
//  Created by Ramadhan Kalih Sewu on 11/06/22.
//

import Foundation
import UIKit

/// present a view controller from the bottom of the container view (including safe area)
/// this will automatically elevate the view from safe area and increase the height accordingly
class SheetPresentationController: FocusPresentationController
{
    var isNeedElevation = false
    
    public static func getFrameOfPresentedViewInContainerView(_ presentedView: UIView, containerView: UIView, elevated: Bool) -> CGRect
    {
        let targetWidth     = containerView.bounds.width
        let targetHeight    = presentedView.frame.height

        var frame           = containerView.bounds
        frame.origin.y      += frame.size.height - targetHeight
        frame.size.width    = targetWidth
        frame.size.height   = targetHeight
        
        if (elevated)
        {
            let safeAreaBottomInset = containerView.safeAreaInsets.bottom
            frame.origin.y -= safeAreaBottomInset
            frame.size.height += safeAreaBottomInset
        }
        
        return frame
    }
    
    override var frameOfPresentedViewInContainerView: CGRect
    {
        guard let containerView = containerView, let presentedView = presentedView
        else { return .zero }
        
        return SheetPresentationController.getFrameOfPresentedViewInContainerView(presentedView, containerView: containerView, elevated: isNeedElevation)
    }
}
