//
//  TodocEvents.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/03/19.
//  Copyright © 2020 JHH. All rights reserved.
//

import Foundation
import Firebase

extension TodocEvents {
    enum Hospital: EventCommitable {
        case click
        func commit() {
            Analytics.logEvent("hospital_click", parameters: nil)
        }
    }
    
    enum Pharmacy: EventCommitable {
        case click
        func commit() {
            Analytics.logEvent("pharmacy_click", parameters: nil)
        }
    }
    
    enum TimeFilter: EventCommitable {
        case click
        case confirm(start: String, end: String)
        case close
        case dimmed
        case startClick
        case endClick
        case refresh
        
        func commit() {
            switch self {
            case .click:
                Analytics.logEvent("time_filter_click", parameters: nil)
            case .confirm(let start, let end):
                Analytics.logEvent("time_filter_complete_click", parameters: [
                    "start": start,
                    "end"  : end]
                )
            case .close:
                Analytics.logEvent("time_filter_close_click", parameters: nil)
                
            case .dimmed:
                Analytics.logEvent("time_filter_dimmed_click", parameters: nil)
                
            case .startClick:
                Analytics.logEvent("time_filter_start_click", parameters: nil)
                
            case .endClick:
                Analytics.logEvent("time_filter_end_click", parameters: nil)
                
            case .refresh:
                Analytics.logEvent("time_filter_refresh_click", parameters: nil)
            }
        }
    }
    
    enum MedicalCategory: EventCommitable {
        case click
        case type(type: String)
        case refresh
        
        func commit() {
            switch self {
            case .click:
                Analytics.logEvent("medical_category_click", parameters: nil)
            case .type(let type):
                Analytics.logEvent("medical_category_type_click", parameters: ["type":type])
            case .refresh:
                Analytics.logEvent("medical_category_refresh_click", parameters: nil)
            }
        }
    }
    
    enum Marker: EventCommitable {
        case click(id: String, name: String, category: String, type: String)
        case detail(id: String, name: String, category: String, type: String)
        case call
        case navi
        case dimmed
        case bottomDragEnd
        case refreshInMarker
        
        func commit() {
            switch self {
            case .click(let id, let name, let category, let type):
                Analytics.logEvent("marker_preview_click", parameters: [
                    "id"      : id,
                    "name"    : name,
                    "category": category,
                    "type"    : type
                ])
            case .detail(let id, let name, let category, let type):
                Analytics.logEvent("marker_preview_detail_click", parameters: [
                    "id"      : id,
                    "name"    : name,
                    "category": category,
                    "type"    : type
                ])
            case .call:
                Analytics.logEvent("marker_preview_call_click", parameters: nil)
            case .navi:
                Analytics.logEvent("marker_preview_navi_click", parameters: nil)
            case .dimmed:
                Analytics.logEvent("marker_preview_dimmed_click", parameters: nil)
            case .bottomDragEnd:
                Analytics.logEvent("marker_preview_bottom_drag", parameters: nil)
            case .refreshInMarker:
                Analytics.logEvent("marker_preview_retry_click", parameters: nil)
            }
        }
    }
    
    enum Cluster: EventCommitable {
        case click
        case detail(id: String, name: String, category: String, type: String)
        case close
        
        func commit() {
            switch self {
            case .click:
                Analytics.logEvent("marker_cluster_click", parameters: nil)
            case .detail(let id, let name, let category, let type):
                Analytics.logEvent("marker_cluster_detail_click", parameters: [
                    "id"      : id,
                    "name"    : name,
                    "category": category,
                    "type"    : type
                ])
            case .close:
                Analytics.logEvent("marker_cluster_close", parameters: nil)
            }
        }
    }
    
    enum Around: EventCommitable {
        case click(type: String)
        case sortClick
        
        func commit() {
            switch self {
            case .click(let type):
                Analytics.logEvent("around_list_click", parameters: ["type":type])
            case .sortClick:
                Analytics.logEvent("around_list_sort_click", parameters: nil)
            }
        }
    }
    
    enum Detail: EventCommitable {
        case mapTouch
        case navi
        case call
        case close
        
        func commit() {
            switch self {
            case .mapTouch:
                Analytics.logEvent("detail_map_click", parameters: nil)
            case .navi:
                Analytics.logEvent("detail_navi_click", parameters: nil)
            case .call:
                Analytics.logEvent("detail_call_click", parameters: nil)
            case .close:
                Analytics.logEvent("detail_close_click", parameters: nil)
            }
        }
    }
    
    enum Retry: EventCommitable {
        case click
        func commit() {
            Analytics.logEvent("retry_click", parameters: nil)
        }
    }
    
    enum Camera: EventCommitable {
        case click
        func commit() {
            Analytics.logEvent("camera_click", parameters: nil)
        }
    }
}
