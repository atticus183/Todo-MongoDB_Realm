//
//  UIViewController+Extensions.swift
//  Todo-MongoDB_Realm
//
//  Created by Josh R on 5/16/21.
//

import SwiftUI
import UIKit

#if DEBUG

//Credit: https://fluffy.es/xcode-previews-uikit/

@available(iOS 13, *)
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        // this variable is used for injecting the current view controller
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func toPreview() -> some View {
        // inject self (the current view controller) for the preview
        Preview(viewController: self)
    }
}
#endif
