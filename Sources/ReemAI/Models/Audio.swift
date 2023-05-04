//
//  Audio.swift
//  Kasem
//
//  Created by Qasim Al on 5/2/23.
//

import Foundation

// MARK: - Audio Request
public struct AudioRequest: FileUploadType {
    let file: String
    let model: AudioModel = .whisper
    let prompt: String?
    let responseFormat: AudioReponseFormat = .json
    let temperature: Double
    let language: Language?

    public init(file: String, prompt: String?, temperature: Double?, language: Language?) {
        self.file = file
        self.prompt = prompt
        self.temperature = temperature ?? 0
        self.language = language
    }

    public func createBody(boundary: String, mimeType: MIMEType) throws -> Data {
        let fileURL = URL(fileURLWithPath: file)
        let fileData = try Data(contentsOf: fileURL)
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType.named)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("\(boundaryPrefix)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(model.rawValue)\r\n".data(using: .utf8)!)
        if let prompt = prompt {
            body.append("\(boundaryPrefix)".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"prompt\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(prompt)\r\n".data(using: .utf8)!)
        }
        if let language = language {
            body.append("\(boundaryPrefix)".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"language\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(language.rawValue)\r\n".data(using: .utf8)!)
        }
        body.append("\(boundaryPrefix)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"response_format\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(responseFormat.rawValue)\r\n".data(using: .utf8)!)
        body.append("\(boundaryPrefix)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"temperature\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(temperature)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}

// MARK: - Audio Result
public struct AudioResult: Decodable {
    public let text: String
}

// MARK: File Upload
public protocol FileUploadType {
    func createBody(boundary: String, mimeType: MIMEType) throws -> Data
}

