//
//  Result+utils.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

// TODO: move to separate package and test
extension Result {
    var successOrNil: Success? {
        switch self {
        case let .success(result):
            return result
        case .failure:
            return nil
        }
    }

    var failureOrNil: Failure? {
        switch self {
        case .success:
            return nil
        case let .failure(error):
            return error
        }
    }

    func mapError<NewErrorType>(
        _ mappingError: @escaping (Failure) -> NewErrorType
    ) -> Result<Success, NewErrorType> {
        switch self {
        case let .success(result):
            return .success(result)
        case let .failure(error):
            return .failure(mappingError(error))
        }
    }
}
