//
//  DetailViewReactor.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/06.
//  Copyright © 2020 JHH. All rights reserved.
//

import Domain

import Foundation
import ReactorKit
import RxCocoa
import RxSwift

final class DetailViewReactor: Reactor {
    private let service: FacilitiesUseCase
    var initialState: State = State()
    
    enum Action {
        case viewDidLoad(type: Model.Todoc.MedicalType, id: String)
    }
    
    // represent state changes
    enum Mutation {
        case setData(Model.Todoc.DetailFacility)
        case setError(Error)
    }
    
    // represents the current view state
    struct State {
        var data: Model.Todoc.DetailFacility?
        var errorMessage = ""
    }
    
    init(service: FacilitiesUseCase) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad(let type, let id):
            return self.service.detailFacility(type, facilityId: id)
                .map { result in
                    switch result {
                    case .success(let facility):
                        return .setData(facility)
                    case .failure(let error):
                        return .setError(error)
                    }
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setData(let facility):
            state.data = facility
            return state
            
        case .setError(let error):
            state.errorMessage = error.localizedDescription
            return state
        }
    }
}
