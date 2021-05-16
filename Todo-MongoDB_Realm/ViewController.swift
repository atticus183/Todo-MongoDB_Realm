//
//  ViewController.swift
//  Todo-MongoDB_Realm
//
//  Created by Josh R on 5/16/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue
    }


}

// MARK: SwiftUI Preview for UIKit

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ViewController_Preview: PreviewProvider {

    static var previews: some View {
        ViewController().toPreview().edgesIgnoringSafeArea(.all)
    }
}
#endif
