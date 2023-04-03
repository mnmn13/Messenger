//
//  OpenAIManager.swift
//  Messenger
//
//  Created by MN on 02.04.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import OpenAISwift

final class OpenAIManager {
    
    static let shared = OpenAIManager()
    
    private init() {}
    
    private var token: OpenAISwift?
    
    func openAIInit() {
        self.token = OpenAISwift(authToken: "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")
    }
    
    func getResponse(text: String, completion: @escaping ResultClosure<String, Error>) {
        token?.sendCompletion(with: text, model: .gpt3(.davinci), maxTokens: 2048, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
