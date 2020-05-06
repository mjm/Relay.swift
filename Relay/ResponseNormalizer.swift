struct ResponsePayload {
    var errors: [GraphQLError]?
    var fieldPayloads: [Any]
    // TODO other payloads
    var source: RecordSource
    var isFinal: Bool
}

class ResponseNormalizer {
    private var recordSource: RecordSource
    private let variables: AnyEncodable
    private let request: RequestDescriptor

    private var path: [String] = []

    init(source: RecordSource, variables: AnyEncodable, request: RequestDescriptor) {
        self.recordSource = source
        self.variables = variables
        self.request = request
    }

    static func normalize(
        recordSource: RecordSource,
        selector: NormalizationSelector,
        data: [String: Any],
        request: RequestDescriptor) -> ResponsePayload {
        return ResponseNormalizer(
            source: recordSource,
            variables: selector.variables,
            request: request
        ).normalizeResponse(selector: selector, data: data)
    }

    func normalizeResponse(selector: NormalizationSelector, data: [String: Any]) -> ResponsePayload {
        guard var record = recordSource[selector.dataID] else {
            preconditionFailure("Expected root record \(selector.dataID) to exist")
        }

        traverseSelections(node: selector.node, record: &record, data: data)
        recordSource[selector.dataID] = record

        return ResponsePayload(errors: [], fieldPayloads: [], source: recordSource, isFinal: false)
    }

    private func traverseSelections(node: NormalizationNode, record: inout Record, data: [String: Any]) {
        for selection in node.selections {
            switch selection {
            case .field(let field):
                normalizeField(parent: node, field: field, record: &record, data: data)
            case .inlineFragment(let fragment):
                if fragment.type == record.typename {
                    traverseSelections(node: fragment, record: &record, data: data)
                }
            default:
                preconditionFailure("not implemented")
            }
        }
    }

    private func normalizeField(parent: NormalizationNode, field: NormalizationField, record: inout Record, data: [String: Any]) {
        let storageKey = getStorageKey(field: field, variables: variables)
        guard let fieldValue = data[field.responseKey] else {
            record[storageKey] = nil
            return
        }

        if field is NormalizationScalarField {
            record[storageKey] = fieldValue
        } else if let field = field as? NormalizationLinkedField {
            path.append(field.responseKey)
            if field.plural {
                normalizePluralLink(field: field, record: &record, storageKey: storageKey, fieldValue: fieldValue)
            } else {
                normalizeLink(field: field, record: &record, storageKey: storageKey, fieldValue: fieldValue)
            }
            path.removeLast()
        }
    }

    private func normalizeLink(field: NormalizationLinkedField, record: inout Record, storageKey: String, fieldValue: Any) {
        guard let fieldValue = fieldValue as? [String: Any] else {
            preconditionFailure("Expected data for field \(storageKey) to be a dictionary")
        }

        let typeName = field.concreteType ?? getRecordType(fieldValue)

        let nextID = DataID.get(fieldValue, typename: typeName)
            ?? record.getLinkedRecordID(storageKey)
            ?? .generateClientID()

        record.setLinkedRecordID(storageKey, nextID)

        var nextRecord = recordSource[nextID] ?? Record(dataID: nextID, typename: typeName)
        recordSource[nextID] = nextRecord
        traverseSelections(node: field, record: &nextRecord, data: fieldValue)
        recordSource[nextID] = nextRecord
    }

    private func normalizePluralLink(field: NormalizationLinkedField, record: inout Record, storageKey: String, fieldValue: Any) {
        guard let fieldValue = fieldValue as? [[String: Any]?] else {
            preconditionFailure("Expected data for field \(storageKey) to be an array of dictionaries")
        }

        let prevIDs = record.getLinkedRecordIDs(storageKey)
        var nextIDs: [DataID?] = []

        for (i, item) in fieldValue.enumerated() {
            guard let item = item else {
                nextIDs.append(nil)
                continue
            }

            path.append("\(i)")
            let typeName = field.concreteType ?? getRecordType(item)
            let nextID = DataID.get(item, typename: typeName)
                ?? prevIDs?[i]
                ?? record.dataID.clientID(storageKey: storageKey, index: i)
            nextIDs.append(nextID)

            var nextRecord = recordSource[nextID] ?? Record(dataID: nextID, typename: typeName)
            recordSource[nextID] = nextRecord
            traverseSelections(node: field, record: &nextRecord, data: item)
            recordSource[nextID] = nextRecord
            path.removeLast()
        }

        record.setLinkedRecordIDs(storageKey, nextIDs)
    }
}

private func getRecordType(_ data: [String: Any]) -> String {
    guard let typeName = data["__typename"] as? String else {
        preconditionFailure("Expected a string in __typename")
    }
    return typeName
}
