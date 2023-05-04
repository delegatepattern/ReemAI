//
//  Edit.swift
//  Kasem
//
//  Created by Qasim Al on 5/3/23.
//

import Foundation

// MARK: Edit
public struct Edit {
    public struct Request {
        let model: EditModel
        let input: String?
        let instruction: String
        let number: Int
        let temperature: Double?
        let topProbability: Double?

        init(model: EditModel, input: String?, instruction: String, number: Int, temperature: Double?, topProbability: Double?) {
            self.model = model
            self.input = input ?? ""
            self.instruction = instruction
            self.number = number
            self.temperature = temperature ?? 1
            self.topProbability = topProbability ?? 1
        }

    }
}

extension Edit.Request: Encodable {
    enum CodingKeys: String, CodingKey {
        case model
        case input
        case instruction
        case number = "n"
        case temperature
        case topProbability = "top_p"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(model.rawValue, forKey: .model)
        try container.encodeIfPresent(input, forKey: .input)
        try container.encode(instruction, forKey: .instruction)
        try container.encode(number, forKey: .number)
        try container.encodeIfPresent(temperature, forKey: .temperature)
        try container.encodeIfPresent(topProbability, forKey: .topProbability)
    }
}

// MARK: Result
public extension Edit {
    struct Result: Decodable {
        public let object: ObjectType
        public let created: String
        public let choices: [Choice]
        public let usage: Usage

        enum CodingKeys: String, CodingKey {
            case object
            case created
            case choices
            case usage
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Edit.Result.CodingKeys.self)
            let objectString = try container.decode(String.self, forKey: .object)
            self.object = ObjectType(rawValue: objectString) ?? .edit

            self.created = try container.decode(Double.self, forKey: .created).formattedDate
            self.choices = try container.decode([Edit.Result.Choice].self, forKey: .choices)
            self.usage = try container.decode(Usage.self, forKey: .usage)
        }
    }
}

public extension Edit.Result {
    struct Choice: Decodable {
        public let text: String
        public let index: Int

        enum CodingKeys: String, CodingKey {
            case text
            case index
        }
    }
}
