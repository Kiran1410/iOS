//
//  DynamicLoader.swift
//  UnityiOSPOC
//
//  Created by Kavish Joshi on 30/07/24.
//

import Foundation
import UIKit


enum GEType:Int {

    case unity = 0
    
    func path() -> String {
        
        let frmaeworksDir = "/Frameworks/"
    
        switch self {
            case .unity: return frmaeworksDir + "UnityFramework.framework"
        }
    }
}

protocol DynamicLoaderDelegate : class {
    
    func didFailedLoadingBundle( path:String!, loader:DynamicLoader)
    func didRecieveMessage(message : String)
}

class DynamicLoader:NSObject {
    
    private(set) var bundle: Bundle?
    
    private(set) weak var delegate:DynamicLoaderDelegate?
    
    init(delegate:DynamicLoaderDelegate?) {
      
        super.init()
        
        self.delegate = delegate
    }
    
    final internal func loadBundle(path:String) {
        
        let _path = Bundle.main.bundlePath.appending(path)
        
        guard let _bundle = Bundle(path: _path) else {
            print("Framework does not exist at \(_path)")
            return
        }
        
        if _bundle.isLoaded == false {
            
            _bundle.load()
        }
        
        self.bundle = _bundle
    }
    
    func load(completion:((_ controller: UIViewController? )-> Void)?) {
        // override this method to load respective framework
        print("load----->")
    }
    
    func unload() {
        // do additional things to unload game engine
        print("unload----->")

    }
    
    final func unloadBundle() {
        
        self.bundle?.unload()
        self.bundle = nil
    }
    
    func send(message: String) {
        // override this method to send message to framework
        print("send----->\(message)")

    }
    
    final func received(message:String) {
        delegate?.didRecieveMessage(message: message)
    }
    
    
}

