import Relay

struct MoviesListPaginationQuery: Operation {
    var node: ConcreteRequest {
        return ConcreteRequest(
            fragment: ReaderFragment(
                name: "MoviesListPaginationQuery",
                selections: [
                    .fragmentSpread(ReaderFragmentSpread(
                        name: "MoviesList_films",
                        args: [
                            VariableArgument(name: "count", variableName: "count"),
                            VariableArgument(name: "cursor", variableName: "cursor"),
                        ]
                    )),
                ]
            ),
            operation: NormalizationOperation(
                name: "MoviesListPaginationQuery",
                selections: [
                    .field(NormalizationLinkedField(
                        name: "allFilms",
                        args: [
                            VariableArgument(name: "after", variableName: "cursor"),
                            VariableArgument(name: "first", variableName: "count"),
                        ],
                        concreteType: "FilmsConnection",
                        plural: false,
                        selections: [
                            .field(NormalizationLinkedField(
                                name: "edges",
                                concreteType: "FilmsEdge",
                                plural: true,
                                selections: [
                                    .field(NormalizationLinkedField(
                                        name: "node",
                                        concreteType: "Film",
                                        plural: false,
                                        selections: [
                                            .field(NormalizationScalarField(
                                                name: "id"
                                            )),
                                            .field(NormalizationScalarField(
                                                name: "episodeID"
                                            )),
                                            .field(NormalizationScalarField(
                                                name: "title"
                                            )),
                                            .field(NormalizationScalarField(
                                                name: "director"
                                            )),
                                            .field(NormalizationScalarField(
                                                name: "releaseDate"
                                            )),
                                            .field(NormalizationScalarField(
                                                name: "__typename"
                                            )),
                                        ]
                                    )),
                                    .field(NormalizationScalarField(
                                        name: "cursor"
                                    )),
                                ]
                            )),
                            .field(NormalizationLinkedField(
                                name: "pageInfo",
                                concreteType: "PageInfo",
                                plural: false,
                                selections: [
                                    .field(NormalizationScalarField(
                                        name: "endCursor"
                                    )),
                                    .field(NormalizationScalarField(
                                        name: "hasNextPage"
                                    )),
                                ]
                            )),
                        ]
                    )),
                    .handle(NormalizationHandle(
                        kind: .linked,
                        name: "allFilms",
                        args: [
                            VariableArgument(name: "after", variableName: "cursor"),
                            VariableArgument(name: "first", variableName: "count"),
                        ],
                        handle: "connection",
                        key: "MoviesList_allFilms"
                    )),
                ]
            ),
            params: RequestParameters(
                name: "MoviesListPaginationQuery",
                operationKind: .query,
                text: """
query MoviesListPaginationQuery(
  $count: Int = 3
  $cursor: String
) {
  ...MoviesList_films_1G22uz
}

fragment MoviesListRow_film on Film {
  id
  episodeID
  title
  director
  releaseDate
}

fragment MoviesList_films_1G22uz on Root {
  allFilms(first: $count, after: $cursor) {
    edges {
      node {
        id
        ...MoviesListRow_film
        __typename
      }
      cursor
    }
    pageInfo {
      endCursor
      hasNextPage
    }
  }
}
"""
            )
        )
    }

    struct Variables: Relay.Variables {
        var count: Int?

        var cursor: String?

        var asDictionary: [String: Any] {
            [
                "count": count as Any,
                "cursor": cursor as Any,
            ]
        }
    }

    struct Data: Readable, MoviesList_films_Key {
        var fragment_MoviesList_films: FragmentPointer

        init(from data: SelectorData) {
            fragment_MoviesList_films = data.get(fragment: "MoviesList_films")
        }

    }
}