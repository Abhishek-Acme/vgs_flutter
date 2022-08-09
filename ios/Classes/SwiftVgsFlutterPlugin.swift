import Flutter
import UIKit
import VGSCollectSDK

public class SwiftVgsFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vgs_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftVgsFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method){
        case "sendData":
            guard let args = call.arguments as? Dictionary<String, Any> else { return }
            guard let headers = args["headers"] as? Dictionary<String, String> else { return }
            guard let vaultId = args["vaultId"] as? String else { return }
            guard let sandbox = args["sandbox"] as? Bool else { return }
            guard let path = args["path"] as? String else { return }
            guard let request = args["request"] as? String else { return }
            let data = args["data"] as? Dictionary<String, Any>

            sendData(vaultId, sandbox, headers, data, path, request, result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func sendData(_ id: String ,_ sandbox: Bool,_ headers: Dictionary<String, String>,_ data: Dictionary<String, Any>?,_ path:String,_ request:String, _ result: @escaping FlutterResult) {
        let collect = VGSCollect(id: id, environment: sandbox ?  .sandbox: .live)
        let requestType = getRequestType(request: request)

        collect.customHeaders = headers

        collect.sendData(path: path, method: requestType, extraData: data) { (response) in
            switch response {
            case .success(_, let data, _):
                result(data.utf8String)
                return
            case .failure(let code, let data, _, let error):
                result(FlutterError(code: code.description, message: error.debugDescription, details: data.utf8String))
                return
            }
        }

    }

    func getRequestType(request:String)->HTTPMethod{
        switch(request){
        case "POST":
            return HTTPMethod.post
        case "PUT":
            return HTTPMethod.put
        case "GET":
            return HTTPMethod.get
        case "DELETE":
            return HTTPMethod.delete
        case "PATCH":
            return HTTPMethod.patch
        default:
            return HTTPMethod.post
        }
    }
}

extension Optional where Wrapped == Data {
    var utf8String: String? {
        return self == nil ? nil : String(decoding: self!, as: UTF8.self)
    }
}
