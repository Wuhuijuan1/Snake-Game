//
//  RxObservable+Extension.swift
//  SmartCam View
//
//  Created by YuanLiYong on 2022/1/14.
//

import Foundation
import RxSwift
import RxCocoa

@propertyWrapper
class RxObservable<T> {
    private var value: T
    private let behaviorRelay: RxCocoa.BehaviorRelay<T>
    var wrappedValue: T {
        get { value }
        set {
            value = newValue
            behaviorRelay.accept(newValue)
        }
    }

    var projectedValue: RxSwift.Observable<T> { behaviorRelay.asDriver().asObservable() }

    init(wrappedValue: T) {
        value = wrappedValue
        behaviorRelay = BehaviorRelay(value: value)
    }

    required init(from decoder: Decoder) throws where T: Codable {
        let container = try decoder.singleValueContainer()
        if let decodeValueArray = try? container.decode([T].self) {
            value = decodeValueArray[0]
        } else {
            let decodeValue = try container.decode(T.self)
            value = decodeValue
        }
        behaviorRelay = BehaviorRelay(value: value)
    }
}


// MARK: - Codable
extension RxObservable: Codable where T: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([value])
    }
}

struct RxObservableExtension<Element> {
    let base: RxSwift.Observable<Element>
    init(_ base: RxSwift.Observable<Element>) {
        self.base = base
    }
}

extension RxSwift.Observable {
    var rsp: RxObservableExtension<Element> { RxObservableExtension(self) }
}

extension RxObservableExtension {
    func subscribe(onNext: ((Element) -> Void)? = nil) -> RxSwift.Disposable {
        base.subscribe(onNext: onNext, onError: nil, onCompleted: nil, onDisposed: nil)
    }
}
