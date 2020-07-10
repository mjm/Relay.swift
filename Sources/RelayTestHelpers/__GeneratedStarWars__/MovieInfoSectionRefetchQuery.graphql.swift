// Auto-generated by relay-compiler. Do not edit.

import Relay

struct MovieInfoSectionRefetchQuery {
    var variables: Variables

    init(variables: Variables) {
        self.variables = variables
    }

    static var node: ConcreteRequest {
        ConcreteRequest(
            fragment: ReaderFragment(
                name: "MovieInfoSectionRefetchQuery",
                type: "Root",
                selections: [
                    .field(ReaderLinkedField(
                        name: "node",
                        args: [
                            VariableArgument(name: "id", variableName: "id")
                        ],
                        plural: false,
                        selections: [
                            .fragmentSpread(ReaderFragmentSpread(
                                name: "MovieInfoSection_film"
                            ))
                        ]
                    ))
                ]),
            operation: NormalizationOperation(
                name: "MovieInfoSectionRefetchQuery",
                selections: [
                    .field(NormalizationLinkedField(
                        name: "node",
                        args: [
                            VariableArgument(name: "id", variableName: "id")
                        ],
                        plural: false,
                        selections: [
                            .field(NormalizationScalarField(
                                name: "__typename"
                            )),
                            .field(NormalizationScalarField(
                                name: "id"
                            )),
                            .inlineFragment(NormalizationInlineFragment(
                                type: "Film",
                                selections: [
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
                                    ))
                                ]
                            ))
                        ]
                    ))
                ]),
            params: RequestParameters(
                name: "MovieInfoSectionRefetchQuery",
                operationKind: .query,
                text: """
query MovieInfoSectionRefetchQuery(
  $id: ID!
) {
  node(id: $id) {
    __typename
    ...MovieInfoSection_film
    id
  }
}

fragment MovieInfoSection_film on Film {
  id
  episodeID
  title
  director
  releaseDate
}
"""))
    }
}


extension MovieInfoSectionRefetchQuery {
    struct Variables: VariableDataConvertible {
        var id: String

        var variableData: VariableData {
            [
                "id": id,
            ]
        }
    }

    init(id: String) {
        self.init(variables: .init(id: id))
    }
}

#if swift(>=5.3) && canImport(RelaySwiftUI)

import RelaySwiftUI

@available(iOS 14.0, macOS 10.16, tvOS 14.0, watchOS 7.0, *)
extension RelaySwiftUI.QueryNext.WrappedValue where O == MovieInfoSectionRefetchQuery {
    func get(id: String, fetchKey: Any? = nil) -> RelaySwiftUI.QueryNext<MovieInfoSectionRefetchQuery>.Result {
        self.get(.init(id: id), fetchKey: fetchKey)
    }
}

#endif

extension MovieInfoSectionRefetchQuery {
    struct Data: Decodable {
        var node: Node_node?

        struct Node_node: Decodable, MovieInfoSection_film_Key {
            var fragment_MovieInfoSection_film: FragmentPointer
        }
    }
}

extension MovieInfoSectionRefetchQuery: Relay.Operation {}
