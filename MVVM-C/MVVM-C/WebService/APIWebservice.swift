//
//  APIWebservice.swift
//  MVVM-C
//
//  Created by michael.p.siapno on 14/09/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

public enum APINetworkState {
    case idle
    case started
    case finished
    case error(Error)
}

public enum APIWebserviceError: Error {
    case invalidURL
    case requestError
    case responseError(Error, code: Int, data: Data?)
    case parseError(Data)
    case noToken
    case apiError(String)
    
    public var errorMessage: String {
        switch self {
        case .apiError(let string):
            return "APIError: \(string)"
        case .requestError:
            return "RequestError"
        case .responseError(let err, let code, let data):
            var dataErrorString = ""
            if let apiData = data, let dataString = String(data: apiData, encoding: .utf8) {
               dataErrorString = dataString
            }
            return "\(err) code:\(code) data: \(dataErrorString)"
        case .parseError(let data):
            var dataErrorString = ""
            if let dataString = String(data: data, encoding: .utf8) {
               dataErrorString = dataString
            }
            return "Parse Error: \(dataErrorString)"
        case .noToken:
            return "No Token"
        case .invalidURL:
            return "Invalid URL"
        }
    }
}

public extension APIWebserviceError {
    static func errorModelFromError<E: Codable>(_ error: Error) -> E? {
        if let apiError = error as? APIWebserviceError {
            switch apiError {
            case .parseError(let dataError):
                return try? JSONDecoder().decode(E.self, from: dataError)
            case .responseError(_, _, let data):
                if let errorData = data {
                    return try? JSONDecoder().decode(E.self, from: errorData)
                }
                return nil
            default:
                return nil
            }
        }
        return nil
    }
}

public enum ContentDataType {
    case form
    case multiPart
}

fileprivate struct APIWebserviceConstants {
    static let timeout: TimeInterval = 60 * 2
}

internal class APIRequest {
    static let shared = APIRequest();
    fileprivate let defaultConfig: URLSessionConfiguration = {
        let defConfig = URLSessionConfiguration.default
        defConfig.urlCache = nil
        defConfig.timeoutIntervalForRequest = APIWebserviceConstants.timeout
        defConfig.timeoutIntervalForResource = APIWebserviceConstants.timeout
        return defConfig
    }()
    fileprivate lazy var manager = Alamofire.SessionManager(configuration: defaultConfig)
    func change(config: URLSessionConfiguration = URLSessionConfiguration.default) {
        let configuration = config
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = APIWebserviceConstants.timeout
        configuration.timeoutIntervalForResource = APIWebserviceConstants.timeout
        manager = Alamofire.SessionManager(configuration: configuration)
    }
}

public protocol APIWebservice {
    var baseURL: String { get }
    var endpoint: String { get }
    var header: [String: String]? { get }
    var params: [String: Any]? { get }
    var mutiPartImages: [UIImage]? { get }
    var method: HTTPMethod { get }
    var contentType: ContentDataType { get }
    var parameterEncoding: ParameterEncoding { get }
    func request<T: Codable>() -> Single<T>
    var retrifier: RequestRetrier? { get }
    var dateFormatter: DateFormatter? { get }
}

public extension Request {
    func debugLog() -> Self {
        debugPrint("=======================================")
        debugPrint(self)
        debugPrint("=======================================")
        return self
    }
}

public extension APIWebservice {
    var header: [String: String]? {
        
        return nil
    }
    
    var contentType: ContentDataType {
        return ContentDataType.form
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var mutiPartImages: [UIImage]? {
        return nil
    }
    
    var retrifier: RequestRetrier? {
        return nil
    }
    
    var dateFormatter: DateFormatter? {
        return nil
    }
    
    // disabled due to deep enum
    // swiftlint:disable cyclomatic_complexity function_body_length
    func request<T: Codable>() -> Single<T> {
        var requestParams = params ?? [:]
        var urlRequestPath = "\(baseURL)\(endpoint)"
        var apiMethod = method
        var apiHeader = header
    
        let contentDataType = contentType
        let multiPartDataImages = mutiPartImages
        let paramEncoding = parameterEncoding
        let jsonDataFormatter = dateFormatter
        return Single<T>.create(subscribe: { single -> Disposable in
            guard let url = URL(string: urlRequestPath) else {
                single(.error(APIWebserviceError.invalidURL))
                print("INVALID --> \(urlRequestPath)")
                return Disposables.create()
            }
            var encoding: ParameterEncoding = paramEncoding
            switch apiMethod {
            case .get:
                encoding = URLEncoding.default
            default:
                break
            }
            
            if contentDataType == ContentDataType.multiPart {
                apiHeader?["Content-type"] = "multipart/form-data"
                let requestMgr = APIRequest.shared.manager
                requestMgr.session.configuration.timeoutIntervalForRequest = APIWebserviceConstants.timeout
                requestMgr.session.configuration.timeoutIntervalForResource = APIWebserviceConstants.timeout
                requestMgr.upload(multipartFormData: { multipartFormData in
                    requestParams.forEach { arg in
                        let (key, val) = arg
                        if let valData = "\(val)".data(using: String.Encoding.utf8) {
                            multipartFormData.append(valData, withName: key)
                        }
                    }
                    
                    multiPartDataImages?.enumerated().forEach { index, uploadImage in
                        if let imageData = uploadImage.jpegData(compressionQuality: 0.2) {
                           multipartFormData.append(imageData,
                                                    withName: "file",
                                                    fileName: "image-\(index).jpeg",
                                                    mimeType: "image/jpeg")
                        }
                    }
                    
                }, usingThreshold: UInt64.init(),
                   to: url,
                   method: apiMethod,
                   headers: apiHeader,
                   encodingCompletion: { uploadResult in
                    
                    switch uploadResult {
                    case .success(let uploadRequest, _, _):
                        uploadRequest.debugLog()
                        uploadRequest.responseData(completionHandler: { responseData in
                            if let uploadResponseData = responseData.data,
                                let model: T = try? JSONDecoder().decode(T.self, from: uploadResponseData) {
                                single(.success(model))
                            } else {
                                if let uData = responseData.data,
                                    let strData = String(data: uData, encoding: String.Encoding.utf8) {
                                    let message = StringDataResponse(strData)
                                    if T.self is StringDataResponse.Type, let msg = message as? T {
                                        single(.success(msg))
                                    } else {
                                        print("error request")
                                        single(.error(APIWebserviceError.requestError))
                                    }
                                } else {
                                    single(.error(APIWebserviceError.requestError))
                                }
                                
                            }
                        })
                    case .failure(let error):
                        print("ERROR: upload failed \(error)")
                        single(.error(APIWebserviceError.requestError))
                    }
                })
                return Disposables.create()
            }
            let requestMgr = APIRequest.shared.manager
            requestMgr.session.configuration.timeoutIntervalForRequest = APIWebserviceConstants.timeout
            requestMgr.session.configuration.timeoutIntervalForResource = APIWebserviceConstants.timeout
            requestMgr.retrier = self.retrifier
            let dataRequest = requestMgr.request(url, method: apiMethod, parameters: requestParams,
                              encoding: encoding, headers: apiHeader)
            dataRequest.debugLog()
            if self.retrifier != nil {
                dataRequest.validate()
            }
                dataRequest.responseData(completionHandler: { data in
                    if let dataError = data.error {
                        if let errorResponseData = data.data,
                            let errorDataString = String(data: errorResponseData, encoding: .utf8) {
                            print("ERROR: \(errorDataString)")
                            single(.error(APIWebserviceError.responseError(dataError, code: data.response?.statusCode ?? 0, data: errorResponseData)))
                        } else {
                            single(.error(APIWebserviceError.responseError(dataError, code: data.response?.statusCode ?? 0, data: nil)))
                        }
                        
                    } else if let dataResponse = data.data {
                        do {
                            
                            let emptyModel = AlwaysSuccess()
                            if T.self is AlwaysSuccess.Type, let emptModel = emptyModel as? T  {
                                single(.success(emptModel))
                                return
                            }
                            
                            let jsonDecoder = JSONDecoder()
                            if let coderDateFormatter = jsonDataFormatter {
                                jsonDecoder.dateDecodingStrategy = .custom { decoder -> Date in
                                    let container = try decoder.singleValueContainer()
                                    let dateStr = try container.decode(String.self)
                                    guard let formattedDate = coderDateFormatter.date(from: dateStr) else {
                                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
                                    }
                                    return formattedDate
                                }
                            }
                            let model: T = try jsonDecoder.decode(T.self, from: dataResponse)
                            single(.success(model))
                        } catch {
                            print("Parse Error: \(error)")
                            if let strData = String(data: dataResponse, encoding: String.Encoding.utf8) {
                                print("ERROR: \(strData)")
                            }
                            single(.error(APIWebserviceError.parseError(dataResponse)))
                        }
                    } else {
                        single(.error(APIWebserviceError.requestError))
                    }
                })
            return Disposables.create {
                dataRequest.cancel()
            }
        }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
    }
    
}
