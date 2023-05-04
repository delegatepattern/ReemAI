//
//  NetworkError.swift
//  Kasem
//
//  Created by Qasim Al on 4/29/23.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case deserializeFailed
}
