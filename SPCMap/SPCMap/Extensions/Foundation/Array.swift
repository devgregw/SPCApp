//
//  Array.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/2/23.
//

import CoreLocation
import Foundation
import MapKit

extension Array {
    @inlinable func filterNot(by keyPath: KeyPath<Element, Bool>) -> Array<Element> {
        self.filter { !$0[keyPath: keyPath] }
    }
    
    @inlinable func first(where keyPath: KeyPath<Element, Bool>) -> Element? {
        self.first { $0[keyPath: keyPath] }
    }
    
    init(unsafeMutablePointer: UnsafeMutablePointer<Element>, count: Int) {
        var result: [Element] = []
        var ptr = unsafeMutablePointer
        for _ in 0 ..< count {
            result.append(ptr.pointee)
            ptr = ptr.successor()
        }
        self = result
    }
}

extension LazySequence {
    @inlinable func compactCast<T>(to: T.Type) -> [T] {
        compactMap { $0 as? T }
    }
}

extension Collection {
    func splitFilter(by path: KeyPath<Element, Bool>) -> (`true`: [Element], `false`: [Element]) {
        var `true`: [Element] = []
        var `false`: [Element] = []
        forEach {
            if $0[keyPath: path] {
                `true`.append($0)
            } else {
                `false`.append($0)
            }
        }
        return (true: `true`, false: `false`)
    }
}

extension Collection where Element == OutlookFeature {
    func findTappedOutlook(at coordinate: CLLocationCoordinate2D) -> TappedOutlook? {
        let allPolygons = flatMap { $0.multiPolygons }
        let mapPoint = MKMapPoint(coordinate)
        
        let (significantPolygons, otherPolgons) = allPolygons.splitFilter(by: \.dashed)
        let tappedPolygon = otherPolgons.reversed().first { $0.contains(point: mapPoint) }
        
        guard let tappedPolygon else {
            return .none
        }
        
        let isSignificant = significantPolygons.contains { $0.contains(point: mapPoint) }
        
        return .init(highestRisk: tappedPolygon, isSignificant: isSignificant)
    }
}
