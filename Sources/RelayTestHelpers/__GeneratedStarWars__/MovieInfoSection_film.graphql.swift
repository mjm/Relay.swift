// Auto-generated by relay-compiler. Do not edit.

import Relay

struct MovieInfoSection_film {
    var fragmentPointer: FragmentPointer

    init(key: MovieInfoSection_film_Key) {
        fragmentPointer = key.fragment_MovieInfoSection_film
    }

    static var node: ReaderFragment {
        ReaderFragment(
            name: "MovieInfoSection_film",
            type: "Film",
            selections: [
                .field(ReaderScalarField(
                    name: "id"
                )),
                .field(ReaderScalarField(
                    name: "episodeID"
                )),
                .field(ReaderScalarField(
                    name: "title"
                )),
                .field(ReaderScalarField(
                    name: "director"
                )),
                .field(ReaderScalarField(
                    name: "releaseDate"
                ))
            ])
    }
}


extension MovieInfoSection_film {
    struct Data: Decodable, Identifiable {
        var id: String
        var episodeID: Int?
        var title: String?
        var director: String?
        var releaseDate: String?
    }
}

protocol MovieInfoSection_film_Key {
    var fragment_MovieInfoSection_film: FragmentPointer { get }
}

extension MovieInfoSection_film: Relay.Fragment {}

extension MovieInfoSection_film: Relay.RefetchFragment {
    typealias Operation = MovieInfoSectionRefetchQuery

    static var metadata: Metadata {
        RefetchMetadata(
            path: ["node"],
            identifierField: "id",
            operation: Operation.self)
    }
}

#if swift(>=5.3) && canImport(RelaySwiftUI)

import RelaySwiftUI

extension MovieInfoSection_film_Key {
    @available(iOS 14.0, macOS 10.16, tvOS 14.0, watchOS 7.0, *)
    func asFragment() -> RelaySwiftUI.FragmentNext<MovieInfoSection_film> {
        RelaySwiftUI.FragmentNext<MovieInfoSection_film>(self)
    }
}

#endif