import UIKit
import Flutter
import SwiftyRSA

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let simpleRsaChannel = FlutterMethodChannel(name: "juanito21.com/simple_rsa", binaryMessenger: controller)
    
    simpleRsaChannel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
        guard let method = call.method as? String, let params = call.arguments as? Dictionary<String, String> else {
            result(nil)
            return
        }
        if method == "encrypt", let rsa_public_key = params["publicKey"], let encryptStr = params["txt"] {
            do{
                let publicKey = try PublicKey(pemEncoded: rsa_public_key)
                let clear = try ClearMessage(string: encryptStr, using: .utf8)
                let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
                let data = encrypted.data
                let base64String = encrypted.base64String
                result(base64String)
                return
            }catch{
                result(nil)
                return
            }
        }else if call.method == "decrypt", let rsa_private_key = params["privateKey"], let decryptStr = params["txt"] {
            do{
                let privateKey = try PrivateKey(pemEncoded: rsa_private_key)
                let encrypted = try EncryptedMessage(base64Encoded: decryptStr)
                let clear = try encrypted.decrypted(with: privateKey, padding: .PKCS1)
                let data = clear.data
                let base64String = clear.base64String
                let string = try clear.string(encoding: .utf8)
                result(string)
                return
            }catch{
                result(nil)
                return
            }
        }
        result(nil)        
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

