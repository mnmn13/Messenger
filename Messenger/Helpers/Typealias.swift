//
//  Typealias.swift
//  Messenger
//
//  Created by MN on 24.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import Firebase


typealias UploadPictureCompletion = (Result<String, Error>) -> Void

typealias EmptyClosure = () -> ()
typealias SimpleClosure<T> = (T) -> ()
typealias FirebaseRequestClosure<R: AuthDataResult, E: Error> = (_ result: (Result<R, E>)) -> ()
typealias FirebaseRequestUserClosure<U: FirebaseAuth.User> = (U) -> ()
typealias DoubleSimpleClosure<T, A> = (T, A) -> ()
typealias TrippleSimpleClosure<A, B, C> = (A, B, C) -> ()
typealias DefaultClosure<T, A> = (T) -> (A)
typealias ResultClosure<R, E: Error> = (Result<R, E>) -> ()

typealias UserDataType = [[String: [Double]]]

typealias HashCoded = Codable & Hashable
typealias DictDataType = [String: [String: Any]]
