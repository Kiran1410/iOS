//
//  ViewController.swift
//  UnityiOSPOC
//
//  Created by Kavish Joshi on 30/07/24.
//

import UIKit


class ViewController: UIViewController {
    
    
    var geLoader: UnityGELoader?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadUnity()
    }

    
    func loadUnity() {
        if(self.geLoader == nil)
        {
            self.geLoader = UnityGELoader(delegate: self)
        }
        
        self.geLoader?.load(completion: { (controller) in
            if let aView = controller?.view {
                self.view.addSubview(aView)
            }
        })
    }

}


extension ViewController: DynamicLoaderDelegate {
    
    func didFailedLoadingBundle(path: String!, loader: DynamicLoader) {
       print("didFailedLoadingBundle---->\(path)")
    }
    
    func didRecieveMessage(message: String) {
        print("didRecieveMessage---->\(message)")

    }
}
