import SwiftUI
import RelaySwiftUI
import Foundation

private let filmFragment = graphql("""
fragment MoviesListRow_film on Film {
  id
  episodeID
  title
  director
  releaseDate
}
""")

struct MoviesListRow: View {
    @Fragment<MoviesListRow_film> var film

    @ViewBuilder var body: some View {
        if let film = film {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Episode \(film.episodeID!):")
                        Text(film.title!)
                    }.font(.headline)
                    Text("Directed by \(film.director!)")
                        .font(.footnote)
                }
                Spacer()
                Text(film.releaseYear)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }.padding(.vertical, 4)
        }
    }
}

extension MoviesListRow_film.Data {
    var releaseYear: String {
        String(releaseDate!.split(separator: "-").first!)
    }
}
