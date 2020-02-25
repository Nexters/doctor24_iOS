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
    private let nightService: NightFacilitiesUseCase
    
    var initialState: State = State()
    
    enum Action {
        case viewDidLoad(location: CLLocationCoordinate2D, zoomLevel: Int)
        case facilites(type: Model.Todoc.MedicalType, location: CLLocationCoordinate2D, zoomLevel: Int, day: Model.Todoc.Day, category: Model.Todoc.MedicalType.Category?)
//        case corona(location: CLLocationCoordinate2D)
    }
    
    // represent state changes
    enum Mutation {
        case setPins([Model.Todoc.Facilities])
        case setError(Error)
    }
    
    // represents the current view state
    struct State {
        var pins: [Model.Todoc.Facilities] = [Model.Todoc.Facilities]()
        var errorMessage = ""
    }
    
    init(service: FacilitiesUseCase,
         nightService: NightFacilitiesUseCase) {
        self.service      = service
        self.nightService = nightService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad(let location, let zoomLevel):
            return self.service.facilities(.hospital,
                                           latitude: location.latitude,
                                           longitude: location.longitude,
                                           zoomLevel: zoomLevel)
                .map{ result in
                    switch result {
                    case .success(let facilities):
                        return .setPins(facilities)
                    case .failure(let error):
                        return .setError(error)
                    }
            }
        case .facilites(let type, let location, let zoomLevel, let day, let category):
            return self.service.facilities(type,
                                           latitude: location.latitude,
                                           longitude: location.longitude,
                                           operatingTime: day,
                                           category: category,
                                           zoomLevel: zoomLevel)
                .map  { result in
                    switch result {
                    case .success(let facilities):
                        return .setPins(facilities)
                    case .failure(let error):
                        return .setError(error)
                    }
            }
            
//        case .corona(let location):
//                break
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
