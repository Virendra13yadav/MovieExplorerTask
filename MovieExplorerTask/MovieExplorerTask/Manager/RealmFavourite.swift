//
//  RealmFavourite.swift
//  MovieExplorerTask
//
//  Created by Apple on 24/07/25.
//

import Foundation
import RealmSwift

class FavoriteMovie: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
}

class FavoritesManager {
    static let shared = FavoritesManager()
    private let realm = try! Realm()

    func isFavorite(id: Int) -> Bool {
        return realm.object(ofType: FavoriteMovie.self, forPrimaryKey: id) != nil
    }

    func toggleFavorite(movie: MovieDetail) -> Bool {
        if let existing = realm.object(ofType: FavoriteMovie.self, forPrimaryKey: movie.id) {
            try? realm.write {
                realm.delete(existing)
            }
            return false
        } else {
            let fav = FavoriteMovie()
            fav.id = movie.id
            fav.title = movie.title
            try? realm.write {
                realm.add(fav)
            }
            return true
        }
    }
}
