//
//  OpenAIService.swift
//  Messenger
//
//  Created by MN on 02.04.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

protocol OpenAIServiceType: Service {}

class OpenAIService: Service {
    
    var openAiResponseCallback: SimpleClosure<String>?
    
    let ref = OpenAIManager.shared
    
    
    func getResponse(text: String) {
        ref.getResponse(text: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let text):
                self.openAiResponseCallback?(text)
            case .failure(let error):
                print(error.localizedDescription)
                AlertHelper.showAlert(error.localizedDescription)
            }
        }
    }
}
