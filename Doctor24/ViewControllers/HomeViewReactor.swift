//
//  HomeReactor.swift
//  Doctor24
//
//  Created by gabriel.jeong on 18/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import Foundation
import ReactorKit
import RxCocoa
import RxSwift
import CoreLocation

final class HomeViewReactor: Reactor {
    private let service: FacilitiesUseCase
    
    var initialState: State = State()
    
    enum Action {
        case viewDidLoad(location: CLLocationCoordinate2D)
    }
    
    // represent state changes
    enum Mutation {
        case setPins([Model.Todoc.Facility])
        case setError(Error)
    }
    
    // represents the current view state
    struct State {
        var pins: [Model.Todoc.Facility] = [Model.Todoc.Facility]()
        var errorMessage = ""
    }
    
    init(service: FacilitiesUseCase) {
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad(let location):
            return self.service.facilities(.hospital,
                                           latitude: location.latitude,
                                           longitude: location.longitude)
                .map{ result in
                    switch result {
                    case .success(let facilities):
                        return .setPins(facilities)
                    case .failure(let error):
                        return .setError(error)
                    }
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setPins(let facilities):
            state.pins = facilities
            return state
            
        case .setError(let error):
            state.errorMessage = error.localizedDescription
            return state
        }
    }
}
