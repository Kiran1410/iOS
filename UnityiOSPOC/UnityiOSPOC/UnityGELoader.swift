//
//  UnityGELoader.swift
//  UnityiOSPOC
//
//  Created by Kavish Joshi on 30/07/24.
//

import Foundation
import UnityFramework

class UnityGELoader:DynamicLoader {
    
    private weak var ufw: UnityFramework?
    
    private var bridge: Bridge?
    
    private func UnityFrameworkLoad() -> UnityFramework? {
#if !targetEnvironment(simulator)
        guard let aClass = self.bundle?.principalClass as? UnityFramework.Type,
              let ufw = aClass.getInstance()  else {
            return nil
        }
        
        if ufw.appController() == nil {
            
            // do initial stuff
            // set data bundle identifier
            if let bundle = self.bundle, let id = bundle.bundleIdentifier {
                ufw.setDataBundleId(id.cString(using: .utf8))
            }
        }
        
        ufw.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: nil)
        
        return ufw
#else
        return nil
#endif
    }
  
    private func setUpBridge() {
        
        if let bundle = self.bundle, let bridgeClass = bundle.classNamed("Bridge") as? Bridge.Type {
            self.bridge = bridgeClass.shared()
            self.bridge?.delegate = self
        }
    }
    
    deinit {
        print("UnityDebug - UnityGELoader is deleted")
    }
    
    override init(delegate: DynamicLoaderDelegate?) {
        print("UnityDebug - load unity framework from bundle and setup bridge")

        super.init(delegate: delegate)
        let path = GEType.unity.path()
        
        self.loadBundle(path: path)
        
        self.setUpBridge()
        
        self.ufw = self.UnityFrameworkLoad()
    }
    
    override func load(completion: ((UIViewController?) -> Void)?) {
        
        self.ufw?.appController()?.window.resignKey()
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()

        // TODO: Proper way to share game view
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.3 ) {
            completion?(self.ufw?.unityGLViewController())
        }
    }
    
    @objc override func unload() {
        print("UnityDebug - unload unity framework and delete bridge")

        if let _ufw = self.ufw {
            _ufw.unloadApplication()
            if let appController = _ufw.appController(), let window = appController.window {
                window.isHidden = true
                window.resignKey()
            }
        }
        self.bridge?.delegate = nil
        self.bridge = nil
        self.ufw = nil
    }
    
    override func send(message: String) {
        self.bridge?.send(message)
    }
}


extension UnityGELoader: BridgeDelegate {
    
    func didRecievedMessage(_ message: String) {
        print("UnityDebug - mfromu \(message)")
        self.received(message: message)
    }
}
