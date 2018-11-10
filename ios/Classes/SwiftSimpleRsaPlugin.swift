import Flutter
import UIKit
import SwiftyRSA

public class SwiftSimpleRsaPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "juanito21.com/simple_rsa", binaryMessenger: registrar.messenger())
    let instance = SwiftSimpleRsaPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
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
}
