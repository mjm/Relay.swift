import Combine
import SwiftUI
import Relay

@propertyWrapper
public struct PaginationFragment<F: Relay.PaginationFragment>: DynamicProperty {
    @SwiftUI.Environment(\.fragmentResource) var fragmentResource
    @SwiftUI.Environment(\.queryResource) var queryResource
    @StateObject var loader = PaginationFragmentLoader<F>()
    
    let key: F.Key?

    public init() {
        self.key = nil
    }
    
    public init(_ key: F.Key) {
        self.key = key
    }

    public var wrappedValue: Wrapper? {
        guard let key = key else {
            return nil
        }

        // load the data if needed
        loader.load(from: fragmentResource!, queryResource: queryResource!, key: key)

        guard let data = loader.data else {
            return nil
        }

        return Wrapper(data: data, paging: loader.paging)
    }

    @dynamicMemberLookup
    public struct Wrapper {
        public let data: F.Data
        let paging: Pager<F>

        public subscript<Subject>(dynamicMember keyPath: KeyPath<F.Data, Subject>) -> Subject {
            return data[keyPath: keyPath]
        }

        public func loadNext(_ count: Int) {
            paging.loadNext(count)
        }

        public func loadPrevious(_ count: Int) {
            paging.loadPrevious(count)
        }

        public var hasNext: Bool { paging.hasNext }
        public var hasPrevious: Bool { paging.hasPrevious }
        public var isLoadingNext: Bool { paging.isLoadingNext }
        public var isLoadingPrevious: Bool { paging.isLoadingPrevious }
    }
}
