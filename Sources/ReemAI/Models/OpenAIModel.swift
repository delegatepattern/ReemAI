//
//  OpenAIModel.swift
//  Kasem
//
//  Created by Qasim Al on 4/29/23.
//

import Foundation
// MARK: - Completions Compatible Models
public enum CompletionModel: String {
     case davinci = "text-davinci-003"
     case davinci002 =  "text-davinci-002"
     case curie = "text-curie-001"
     case babbage =  "text-babbage-001"
     case ada =  "text-ada-001"
     case unknown
}

public extension CompletionModel {
    var named: String {
        switch self {
            case .davinci: return self.rawValue
            case .davinci002: return self.rawValue
            case .curie: return self.rawValue
            case .babbage: return self.rawValue
            case .ada: return self.rawValue
            case .unknown: return "Unknown"
        }
    }
}

// MARK: - Object Type
public enum ObjectType: String {
    case completion = "text_completion"
    case chat = "chat.completion"
    case edit = "edit"
    case unknown

    public var named: String {
        switch self {
            case .completion: return self.rawValue
            case .chat: return self.rawValue
            case .edit: return self.rawValue
            case .unknown: return "Unknown"
        }
    }
}

// MARK: - Chat Compatible Models
public enum ChatModel: String {
    case gpt4 = "gpt-4"
    case gpt40314 = "gpt-4-0314"
    case gpt432k = "gpt-4-32k"
    case gpt432k0314 = "gpt-4-32k-0314"
    case gpt35turbo = "gpt-3.5-turbo"
    case gpt35turbo0301 = "gpt-3.5-turbo-0301"
}

// MARK: - Chat Role
public enum Role: String {
    case system = "system"
    case user = "user"
    case assistant = "assistant"

    var named: String {
        switch self {
            case .system: return self.rawValue
            case .user: return self.rawValue
            case .assistant: return self.rawValue
        }
    }
}

// MARK: - Image Size
public enum Size: String {
    case small = "256x256"
    case medium = "512x512"
    case large = "1024x1024"
}

// MARK: - Image Response Format:
public enum ImageReponseFormat: String {
    case url = "url"
    case json = "b64_json"
}

// MARK: - Audio Response Format:
public enum AudioReponseFormat: String {
    case json = "json"
    case text = "text"
}

// MARK: - Audio Model
public enum AudioModel: String {
    case whisper = "whisper-1" // Only whisper-1 is currently available.

    var named: String {
        switch self {
            case .whisper: return self.rawValue
        }
    }
}

// MARK: - MIMEType
public enum MIMEType: String {
    case png = "image/png"
    case jpeg = "image/jpeg"
    case mp3 = "audio/mpeg"
    case mp4 = "video/mp4"
    case mpeg = "video/mpeg"
    case mpga = "audio/mpga"
    case m4a = "audio/mp4"
    case wav = "audio/wav"

    var named: String {
        switch self {
            case .png: return self.rawValue
            case .jpeg: return self.rawValue
            case .mp3: return self.rawValue
            case .mp4: return self.rawValue
            case .mpeg: return self.rawValue
            case .mpga: return self.rawValue
            case .m4a: return self.rawValue
            case .wav: return self.rawValue
        }
    }
}

// MARK: - Edit Models
public enum EditModel: String {
    case textDavinci = "text-davinci-edit-001"
    case codeDavinci = "code-davinci-edit-001"

    var named: String {
        switch self {
            case .textDavinci: return self.rawValue
            case .codeDavinci: return self.rawValue
        }
    }
}
