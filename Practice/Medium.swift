//
//  Medium.swift
//  Practice
//
//  Created by Piyush Sharma on 7/7/18.
//  Copyright © 2018 Piyush Sharma. All rights reserved.
//

import UIKit


//MARK: NETWORK LAYER

//This defines the type of data we expect as response from server
public enum DataType {
    case Json
    case Data
}

//This defines the type of HTTP method used to perform the request
public enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}

//This defines the parameters to pass along with the request
public enum RequestParams {
    case body(_ : [String: Any]?)
    case url(_ : [String: Any]?)
}

//This is the Request protocol you may implement other classes can conform
public protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: RequestParams { get }
    var headers: [String: Any]? { get }
    var dataType: DataType { get }
}

public enum APIRequest {
    case login(username: String, password: String)
    case logout
}

extension APIRequest: Request {
    
    public var path: String {
        switch self {
        case .login( _, _):
            return "/users/login"
        case .logout:
            return "/users/logout"
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .login(let username, let password):
            return .body(["user" : username, "password" : password])
        case .logout:
            return.body([:])
        }
    }
    
    public var headers: [String : Any]? {
        return [:]
    }
    
    public var method: HTTPMethod {
        switch self {
        case .login(_,_):
            return .post
        case .logout:
            return .post
        }
    }
    
    public var dataType: DataType {
        switch self {
        case .login(_,_):
            return .Json
        case .logout:
            return .Json
        }
    }
}


//Environment is a struct which encapsulate all the information
public struct Environment {
    
    //Name of the environment
    public var name: String
    
    //Base URL of the environment
    public var host: String
    
    //This is the list of common headers which will be part of each Request
    public var headers: [String: Any] = [:]
    
    //Cache policy
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    
    //Initialize a new Environment
    public init(_ name: String, host: String) {
        self.name = name
        self.host = host
    }
}


//The dispatcher is responsible to execute a Request and provide the response
public protocol Dispatcher {
    
    //Configure the dispatcher with an environment
    init(environment: Environment)
    
    //This function executes the request and provide a response
    func execute(request: Request, completion: @escaping (Any?) -> ()) throws
}

public class NetworkDispatcher: Dispatcher {
    
    private var environment: Environment
    private var session: URLSession
    
    required public init(environment: Environment) {
        self.environment = environment
        self.session = URLSession(configuration: .default)
    }
    
    public func execute(request: Request, completion: @escaping (Any?) -> ()) throws {
        let apiRequest = try self.prepare(request: request)
        URLSession.shared.dataTask(with: apiRequest) { (data, response, error) in
            let response = Response((r: response as? HTTPURLResponse, d: data, e: error), for: request)
            completion(response)
            }.resume()
    }
    
    private func prepare(request: Request) throws -> URLRequest {
        
        //1. format the endpoint url using host url and path
        let fullUrl = "\(environment.host)/\(request.path)"
        
        //2. create an api request object with the url
        var apiRequest = URLRequest(url: URL(string: fullUrl)!)
        
        //3. set api request parameters either as body or as query params
        switch request.parameters {
        case .body(let params):
            if let params = params as? [String : String] {
                let body = try? JSONEncoder().encode(params)
                apiRequest.httpBody = body
            } else {
                throw NetworkErrors.badInput
            }
            
        case .url(let params):
            if let params = params as? [String : String] {
                let queryParams = params.map { pair  in
                    return URLQueryItem(name: pair.key, value: pair.value)
                }
                guard var components = URLComponents(string: fullUrl) else {
                    throw NetworkErrors.badInput
                }
                components.queryItems = queryParams
                apiRequest.url = components.url
            } else {
                throw NetworkErrors.badInput
            }
        }
        
        //4. set api request header using common enviorment header parameters and specific request parameters
        environment.headers.forEach { apiRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { apiRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        
        //5. set api request http method
        apiRequest.httpMethod = request.method.rawValue
        return apiRequest
    }
}

public enum NetworkErrors: Error {
    case badInput
    case noData
}

public enum Response {
    case json(_: Any)
    case data(_: Data)
    case error(_: Int?, _: Error?)
    
    init(_ response: (r: HTTPURLResponse?, d: Data?, e: Error?), for request: Request) {
        guard response.r?.statusCode == 200, response.e == nil else {
            self = .error(response.r?.statusCode, response.e)
            return
        }
        
        guard let data = response.d else {
            self = .error(response.r?.statusCode, NetworkErrors.noData)
            return
        }
        
        switch request.dataType {
        case .Data:
            self = .data(data)
        case .Json:
            self = .json(data)
        }
    }
}

protocol Worker {
    associatedtype Output
    
    //work request to be executed in dispatcher
    var request: Request { get }
    
    //execute work request in dispatcher
    func doWork(in dispatcher: Dispatcher, completion: @escaping (Output) -> ())
}


class LoginWorker: Worker {
    var username: String
    var password: String
    
    init(user: String, password: String) {
        self.username = user
        self.password = password
    }
    
    var request: Request {
        return APIRequest.login(username: self.username, password: self.password)
    }
    
    func doWork(in dispatcher: Dispatcher, completion: @escaping (Any?) -> ()) {
        do {
            try dispatcher.execute(request: request) { (response) in
                completion(response)
            }
        } catch(let error) {
            print(error)
        }
    }
}


// MARK: CODABLE

class CourseController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonUrl = "http://your_server_endpoint__url"
        let url = URL(string: jsonUrl)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            //decode data to college model object
            let college = College(data: data)
            Disk.store(college!, to: .documents, as: "file.txt")
            let model = Disk.retrieve("file.txt", from: .documents, as: College.self)
            print(model!)
            
            }.resume()
    }
}

protocol Serializable: Codable {
    init?(data: Data?)
    func encode() -> Data?
}

extension Serializable {
    
    init?(data: Data?) {
        guard let data = data else {
            return nil
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self = try! decoder.decode(Self.self, from: data)
    }
    
    func encode() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}


struct College: Serializable {
    var name: String?
    var university: String?
    var course: [Course]?
}

struct Course: Serializable {
    let id: Int?
    let name: String?
    let link: String?
    let image: String?
}


public class Disk {
    
    fileprivate init() { }
    
    enum Directory {
        /// Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory and will be automatically backed up by iCloud.
        case documents
        
        /// Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
        case caches
    }
    
    /// Returns URL constructed from specified directory
    static fileprivate func getURL(for directory: Directory) -> URL {
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        }
        
        if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
    }
    
    
    /**
     *   Store an encodable struct to the specified directory on disk
     *   @object: the encodable struct to store
     *   @directory: where to store the struct
     *   @fileName: what to name the file where the struct data will be stored
     */
    
    static func store<T: Serializable>(_ object: T, to directory: Directory, as fileName: String) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        
        do {
            let data = object.encode()
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /**
     *   Retrieve and convert a struct from a file on disk
     *   @fileName: name of the file where struct data is stored
     *   @directory: directory where struct data is stored
     *   @type: struct type (i.e. Message.self)
     *   @Returns: decoded struct model(s) of data
     */
    
    static func retrieve<T: Serializable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T? {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File at path \(url.path) does not exist!")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let model = type.init(data: data)
            return model
        } else {
            fatalError("No data found  at\(url.path)!")
        }
    }
    
    /// Remove all files at specified directory
    static func clear(_ directory: Directory) {
        let url = getURL(for: directory)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Remove specified file from specified directory
    static func remove(_ fileName: String, from directory: Directory) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    /// Returns BOOL indicating whether file exists at specified directory with specified file name
    static func fileExists(_ fileName: String, in directory: Directory) -> Bool {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
}


