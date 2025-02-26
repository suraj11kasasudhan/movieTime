//
//  MovieDataModel.swift
//  MovieTime
//
//  Created by Suraj on 25/02/25.
//

import Foundation

struct MovieResponse: Codable {
    let search: [Movie]?
    let error:String?
    let response:Bool?
    

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case error = "Error"
        case response = "Response"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.search = try? container.decodeIfPresent([Movie].self, forKey: .search)
        self.error = try? container.decodeIfPresent(String.self, forKey: .error)
        self.response = try? container.decodeIfPresent(Bool.self, forKey: .response)
    }
}

struct Movie: Codable {
    let title: String?
    let year: String?
    let imdbID: String?
    let type: String?
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try? container.decode(String.self, forKey: .title)
        self.year = try? container.decode(String.self, forKey: .year)
        self.imdbID = try? container.decode(String.self, forKey: .imdbID)
        self.type = try? container.decode(String.self, forKey: .type)
        self.poster = try? container.decode(String.self, forKey: .poster)
    }
}

struct MovieDetail: Codable {
    let title: String?
    let year: String?
    let rated: String?
    let released: String?
    let runtime: String?
    let genre: String?
    let director: String?
    let writer: String?
    let actors: String?
    let plot: String?
    let language: String?
    let country: String?
    let awards: String?
    let poster: String?
    let imdbRating: String?
    let imdbVotes: String?
    let boxOffice: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case imdbRating
        case imdbVotes
        case boxOffice = "BoxOffice"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try? container.decode(String.self, forKey: .title)
        self.year = try? container.decode(String.self, forKey: .year)
        self.rated = try? container.decode(String.self, forKey: .rated)
        self.released = try? container.decode(String.self, forKey: .released)
        self.runtime = try? container.decode(String.self, forKey: .runtime)
        self.genre = try? container.decode(String.self, forKey: .genre)
        self.director = try? container.decode(String.self, forKey: .director)
        self.writer = try? container.decode(String.self, forKey: .writer)
        self.actors = try? container.decode(String.self, forKey: .actors)
        self.plot = try? container.decode(String.self, forKey: .plot)
        self.language = try? container.decode(String.self, forKey: .language)
        self.country = try? container.decode(String.self, forKey: .country)
        self.awards = try? container.decode(String.self, forKey: .awards)
        self.poster = try? container.decode(String.self, forKey: .poster)
        self.imdbRating = try? container.decode(String.self, forKey: .imdbRating)
        self.imdbVotes = try? container.decode(String.self, forKey: .imdbVotes)
        self.boxOffice = try? container.decode(String.self, forKey: .boxOffice)
    }
}




