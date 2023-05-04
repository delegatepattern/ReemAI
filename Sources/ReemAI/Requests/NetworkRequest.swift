//
//  NetworkRequest.swift
//  Kasem
//
//  Created by Qasim Al on 4/29/23.
//

import Foundation

protocol NetworkRequest: AnyObject {
    associatedtype ModelType: Decodable
    var urlRequest: URLRequest { get }
    var session: URLSession { get }
    var task: URLSessionDataTask? { get set }
}

extension NetworkRequest {
    func execute() async throws -> ModelType {
        let (data, response) = try await session.data(for: urlRequest)
        if data.isEmpty {
            throw NetworkError.invalidResponse
        }
        guard let result = try deserialize(data, response: response) else {
            throw NetworkError.deserializeFailed
        }
        return result
    }

    func deserialize(_ data: Data?, response: URLResponse?) throws -> ModelType? {
        guard let data = data else { throw NetworkError.invalidResponse }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do    { return try decoder.decode(ModelType.self, from: data) }
        catch { throw NetworkError.deserializeFailed }
    }

    func performUpload(_ body: Data) async throws -> ModelType {
        let (data, response) = try await session.upload(for: urlRequest, from: body)
        if data.isEmpty {
            throw NetworkError.invalidResponse
        }
        guard let result = try deserialize(data, response: response) else {
            throw NetworkError.deserializeFailed
        }
        return result

    }
}


// MARK: - APIRequest
protocol APIRequest: NetworkRequest {
    var url: URL { get }
    var accessToken: String { get }
    var organizationID: String? { get }
}

extension APIRequest {
    var authenticatedURLRequest: URLRequest {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        if let organizationID = organizationID {
            request.setValue(organizationID, forHTTPHeaderField: "OpenAI-Organization")
        }
        return request
    }
}

// MARK: - PostRequest
public class PostRequest<PostType: Encodable, ModelType: Decodable>: APIRequest {
    let url: URL
    let accessToken: String
    let organizationID: String?
    let value: PostType
    var task: URLSessionDataTask?
    let session: URLSession

    init(url: URL, accessToken: String, organizationID: String?, session: URLSession = URLSession.shared, value: PostType) {
        self.url = url
        self.accessToken = accessToken
        self.organizationID = organizationID
        self.session = session
        self.value = value
    }
}

extension PostRequest: NetworkRequest {
    var urlRequest: URLRequest {
        var request = authenticatedURLRequest
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try? encoder.encode(value)
        return request
    }
}

// MARK: - FileUploadRequest
public class FileUploadRequest<UploadType: FileUploadType, ModelType: Decodable>: APIRequest {
    let url: URL
    let accessToken: String
    let organizationID: String?
    let value: UploadType
    var task: URLSessionDataTask?
    let session: URLSession = URLSession.shared
    let boundary = UUID().uuidString
    let mimeType: MIMEType

    init(url: URL, accessToken: String, organizationID: String?, value: UploadType, mimeType: MIMEType) {
        self.url = url
        self.accessToken = accessToken
        self.organizationID = organizationID
        self.value = value
        self.mimeType = mimeType
    }
}

extension FileUploadRequest: NetworkRequest {
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        if let organizationID = organizationID {
            request.setValue(organizationID, forHTTPHeaderField: "OpenAI-Organization")
        }
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? value.createBody(boundary: boundary, mimeType: mimeType)
        return request
    }

    var body: Data? {
        return urlRequest.httpBody
    }
}
