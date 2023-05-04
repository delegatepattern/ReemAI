//
//  ImageGeneration.swift
//  Kasem
//
//  Created by Qasim Al on 5/1/23.
//

import Foundation

// MARK: - ImageGeneration
public struct ImageGeneration {
    public struct Request {
        public let prompt: String
        public let number: Int? // number of images to generate
        public let size: Size //  S: 256x256, M: 512x512, or L: 1024x1024.
        public let responseFormat: ImageReponseFormat // url or b64_json
        public let user: String?
    }
}

// MARK: Request Encodable
extension ImageGeneration.Request: Encodable {
    enum CodingKeys: String, CodingKey {
        case prompt
        case number = "n"
        case size
        case responseFormat = "response_format"
        case user
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prompt, forKey: .prompt)
        try container.encodeIfPresent(number, forKey: .number)
        try container.encode(size.rawValue, forKey: .size)
        try container.encode(responseFormat.rawValue, forKey: .responseFormat)
        try container.encodeIfPresent(user, forKey: .user)
    }
}

// MARK: - Result
public extension ImageGeneration {
    struct Result: Decodable {
        public let created: String
        public let data: [Data]

        enum CodingKeys: String, CodingKey {
            case created
            case data
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: ImageGeneration.Result.CodingKeys.self)
            self.created = try container.decode(Double.self, forKey: ImageGeneration.Result.CodingKeys.created).formattedDate
            self.data = try container.decode([ImageGeneration.Data].self, forKey: ImageGeneration.Result.CodingKeys.data)
        }
    }
}

// MARK: - Data
public extension ImageGeneration {
    struct Data: Decodable {
        public let url: URL

        enum CodingKeys: String, CodingKey {
            case url
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let urlString = try container.decode(String.self, forKey: .url)
            guard let url = URL(string: urlString) else {
                throw DecodingError.dataCorruptedError(forKey: .url, in: container, debugDescription: "Invalid URL string: \(urlString)")
            }
            self.url = url
        }
    }
}
