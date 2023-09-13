//
//  FDNetworkManager.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit
import Alamofire

struct AlamofireManager {
    static var shared: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let session = Alamofire.Session(configuration: configuration)
        return session
    }()
}

struct AlamofireHeaders {
    static func createHeader() -> HTTPHeaders {
        _ = AppManager.shared.version
        let model = UIDevice.current.model
        _ = UIDevice.current.systemVersion
        let language = NSLocale.preferredLanguages.first

        let headers: HTTPHeaders = [
            "language": "\(language)",
            "model": model
        ]
                
//        Log.message(to: headers)
        return headers
    }
}


class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    class func isWifiConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi ?? false
    }
}


class NetworkManager {
    static var downloadFiles: [Any] = [Any]()
    static var isDownloading: Bool = false
    
    class func responseLog(response: AFDataResponse<Any>) {
        Log.message(to: "Response Log Start ==============================")
        if let request = response.request {
            Log.message(to: "Request: \(request)")
            Log.message(to: "=================================================")
        }
        if let respond = response.response {
            Log.message(to: "Respond: \(respond)")
            Log.message(to: "=================================================")
        }
        if let result = response.value as? [String: Any] {
            Log.message(to: "Result: \(result)")
            Log.message(to: "=================================================")
        }
        Log.message(to: "Response Log:  End ================================= " )
    }
        
    class func request(
        method: HTTPMethod,
        url: String,
        param: [String: Any]?,
        completion: @escaping (Data?, Bool, ErrorModel?) -> Void
    ) {
        
        if !Connectivity.isConnectedToInternet {
            Log.message(to: "Yes! internet is not available.")
//            let error = ErrorModel(result: "false", message: "A network connection error has\noccurred. Please check your\nnetwork and try again", data: nil)
//            completion(nil, false, error)
            return
        }

        if AlamofireManager.shared.session.configuration.timeoutIntervalForRequest != 30 {
            let alamofire = Alamofire.Session.default
            alamofire.session.configuration.timeoutIntervalForRequest = 30
            AlamofireManager.shared = alamofire
        }

        var encodingType: ParameterEncoding

        if method == .put || method == .post {
            encodingType = JSONEncoding.default
        } else {
            encodingType = URLEncoding.queryString
        }
        
//        if let p = param { Log.message(to: "param: \(p)") }
        
        AlamofireManager.shared.request(
            url,
            method: method,
            parameters: param,
            encoding: encodingType,
            headers: nil
        ).validate().responseJSON {
            response in
            
            self.responseLog(response: response)

            var success: Bool = false
            switch response.result {
            case let .success(value):
                guard let dic = value as? [String: Any] else {
                    return completion(nil, false, nil)
                }
                
                if let data = response.data {
                    success = true
                    completion(data, success, nil)
                } else {
                    success = false
                    completion(nil, success, nil)
                }
                
                break
            case let .failure(error):
                success = false
                switch error as? AFError {
                case let .some(.invalidURL(url)):
                    Log.message(to: "\(url)")
                case let .some(.parameterEncodingFailed(reason)):
                    Log.message(to: "\(reason)")
                case let .some(.multipartEncodingFailed(reason)):
                    Log.message(to: "\(reason)")
                case let .some(.responseValidationFailed(reason)):
                    Log.message(to: "\(reason)")
                case let .some(.responseSerializationFailed(reason)):
                    Log.message(to: "\(reason)")
                case .none:
                    break
                default:
                    break
                }
                completion(nil, success, nil)
                break
            }
        }
    }
        
}

// 네트 관련 함수
extension NetworkManager {
    // 서버와 통신을 전부다 끊는다.
    class func cancellAll() {
        AlamofireManager.shared.session.getTasksWithCompletionHandler { sessionDataTask, uploadData, downloadData in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }

    // 섹션을 전부다 멈춘다.
    class func stopAllSessions() {
        AlamofireManager.shared.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
        AlamofireManager.shared.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }

    // 특정 통신을 캔슬한다. (현재 string으로 하는데, 태그로 해야하나?)
    class func cancel(url: String) {
        AlamofireManager.shared.session.getTasksWithCompletionHandler { sessionDataTask, _, _ in
            sessionDataTask.forEach {
                if $0.originalRequest?.url?.absoluteString == url {
                    $0.cancel()
                }
            }
        }
    }

    class func cancelTask() {
        AlamofireManager.shared.session.getTasksWithCompletionHandler { sessionDataTask, _, _ in
            sessionDataTask.forEach { $0.cancel() }
        }
    }

    class func cancelDownload() {
        AlamofireManager.shared.session.getTasksWithCompletionHandler { _, _, downloadData in
            downloadData.forEach { $0.cancel() }
        }
    }

    class func cancelUpload() {
        AlamofireManager.shared.session.getTasksWithCompletionHandler { _, uploadData, _ in
            uploadData.forEach { $0.cancel() }
        }
    }
}

// swiftlint:enable all
