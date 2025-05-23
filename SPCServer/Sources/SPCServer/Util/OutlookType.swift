//
//  OutlookType.swift
//  
//
//  Created by Greg Whatley on 4/30/23.
//

import Foundation

enum OutlookType: Hashable {
    enum ConvectiveOutlookType: String {
        case categorical = "cat"
        case wind = "wind"
        case hail = "hail"
        case tornado = "torn"
        
        var systemImage: String {
            switch self {
            case .categorical: return "square.stack.3d.down.forward"
            case .wind: return "wind"
            case .hail: return "cloud.hail"
            case .tornado: return "tornado"
            }
        }
        
        var displayName: String {
            switch self {
            case .categorical: return "Categorical"
            case .tornado: return "Tornado"
            default: return rawValue.capitalized
            }
        }
    }
    
    case convective1(_: ConvectiveOutlookType)
    case convective2(_: ConvectiveOutlookType)
    case convective3(probabilistic: Bool)
    
    case convective4
    case convective5
    case convective6
    case convective7
    case convective8
    
    var day: Int {
        switch self {
        case .convective1: return 1
        case .convective2: return 2
        case .convective3: return 3
        case .convective4: return 4
        case .convective5: return 5
        case .convective6: return 6
        case .convective7: return 7
        case .convective8: return 8
        }
    }
    
    var isConvective: Bool {
        true
    }
    
    var subSection: String {
        switch self {
        case .convective1(let type), .convective2(let type): return type.displayName
        case .convective3(let probabilistic): return probabilistic ? "Probabilistic" : ConvectiveOutlookType.categorical.displayName
        case .convective4, .convective5, .convective6, .convective7, .convective8: return "Probabilistic"
        }
    }
    
    var category: String {
        "Convective"
    }
    
    var path: String {
        switch self {
        case .convective1(let type), .convective2(let type): return "convective/\(day)/\(type.rawValue)"
        case .convective3(let probabilistic): return "convective/\(day)/\(probabilistic ? "prob" : ConvectiveOutlookType.categorical.rawValue)"
        case .convective4, .convective5, .convective6, .convective7, .convective8: return "convective/\(day)"
        }
    }
    
    var convectiveSubtype: ConvectiveOutlookType? {
        switch self {
        case let .convective1(subtype), let .convective2(subtype): return subtype
        case let .convective3(probabilistic): return probabilistic ? nil : ConvectiveOutlookType.categorical
        default: return nil
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
    }
}

extension OutlookType {
    var prefix: String {
        switch self {
        case .convective1: return "day1otlk"
        case .convective2: return "day2otlk"
        case .convective3: return "day3otlk"
        case .convective4: return "day4prob"
        case .convective5: return "day5prob"
        case .convective6: return "day6prob"
        case .convective7: return "day7prob"
        case .convective8: return "day8prob"
        }
    }
    
    var `extension`: String {
        "lyr.geojson"
    }
    
    var suffix: String {
        switch self {
        case let .convective1(type), let .convective2(type): return type.rawValue
        case let .convective3(probabilistic): return probabilistic ? "prob" : ConvectiveOutlookType.categorical.rawValue
        case .convective4, .convective5, .convective6, .convective7, .convective8: return ""
        }
    }
    
    private func centralTimeToUTC(_ time: Int) -> Int {
        let tz = TimeZone(identifier: "America/Chicago")!
        return time + abs(tz.secondsFromGMT() / 36)
    }
    
    var issuances: [Int]? {
        // source: https://www.spc.noaa.gov/misc/about.html#convective_outlook_issuance_times
        switch self {
        case .convective1:
            [2000, 1630, 1300, 1200, 100]
        case .convective2:
            [1730, centralTimeToUTC(100)]
        case .convective3:
            [1930, centralTimeToUTC(230)]
        default:
            nil
        }
    }
}
