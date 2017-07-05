//
//  GetRecommendation.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/05.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

// MARK: - GetDefaultRecommendations
public struct GetDefaultRecommendations<
    Recommendation: RecommendationDecodable,
    Song: SongDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    MusicVideo: MusicVideoDecodable,
    Playlist: PlaylistDecodable,
    Curator: CuratorDecodable,
    Station: StationDecodable,
    Storefront: StorefrontDecodable,
    Genre: GenreDecodable
>: PaginatorRequest {
    public typealias Resource = AppleMusicKit.Resource<Recommendation, Relationships>

    public var scope: AccessScope { return .user }
    public let path: String
    public var parameters: Any? { return makePaginatorParameters(_parameters, request: self) }

    public var limit: Int?
    public var offset: Int?
    private let _parameters: [String: Any]

    public init(type: ResourceType? = nil, locale: Locale? = nil, limit: Int? = nil, offset: Int? = nil) {
        assert(type?.contains(in: .albums, .playlists) ?? true)
        self.init(path: "/v1/me/recommendations",
                  parameters: ["type": type?.rawValue, "l": locale?.languageTag, "limit": limit, "offset": offset].cleaned)
    }

    public init(path: String, parameters: [String: Any]) {
        self.path = path
        _parameters = parameters
        (limit, offset) = parsePaginatorParameters(parameters)
    }
}

extension GetDefaultRecommendations {
    public struct Relationships: Decodable {
        public typealias AnyResource = AppleMusicKit.AnyResource<Song, Album, Artist, MusicVideo, Playlist, Curator, Station, Storefront, Genre, Recommendation, NoRelationships>
        public let contents: [AnyResource]?
        public let recommendations: [Resource]?
    }
}

// MARK: - GetRecommendation
public struct GetRecommendation<
    Recommendation: RecommendationDecodable,
    Song: SongDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    MusicVideo: MusicVideoDecodable,
    Playlist: PlaylistDecodable,
    Curator: CuratorDecodable,
    Station: StationDecodable,
    Storefront: StorefrontDecodable,
    Genre: GenreDecodable
>: PaginatorRequest {
    public typealias Relationships = GetDefaultRecommendations<Recommendation, Song, Album, Artist, MusicVideo, Playlist, Curator, Station, Storefront, Genre>.Relationships
    public typealias Resource = AppleMusicKit.Resource<Recommendation, Relationships>

    public var scope: AccessScope { return .user }
    public let path: String
    public var parameters: Any? { return makePaginatorParameters(_parameters, request: self) }

    public var limit: Int?
    public var offset: Int?
    private let _parameters: [String: Any]

    public init(id: Recommendation.Identifier, locale: Locale? = nil, limit: Int? = nil, offset: Int? = nil) {
        self.init(path: "/v1/me/recommendations/\(id)",
            parameters: ["l": locale?.languageTag, "limit": limit, "offset": offset].cleaned)
    }

    public init(path: String, parameters: [String: Any]) {
        self.path = path
        _parameters = parameters
        (limit, offset) = parsePaginatorParameters(parameters)
    }
}

// MARK: - GetMultipleRecommendations
public struct GetMultipleRecommendations<
    Recommendation: RecommendationDecodable,
    Song: SongDecodable,
    Album: AlbumDecodable,
    Artist: ArtistDecodable,
    MusicVideo: MusicVideoDecodable,
    Playlist: PlaylistDecodable,
    Curator: CuratorDecodable,
    Station: StationDecodable,
    Storefront: StorefrontDecodable,
    Genre: GenreDecodable
>: PaginatorRequest {
    public typealias Relationships = GetRecommendation<Recommendation, Song, Album, Artist, MusicVideo, Playlist, Curator, Station, Storefront, Genre>.Relationships
    public typealias Resource = AppleMusicKit.Resource<Recommendation, Relationships>

    public var scope: AccessScope { return .user }
    public let path: String
    public var parameters: Any? { return makePaginatorParameters(_parameters, request: self) }

    public var limit: Int?
    public var offset: Int?
    private let _parameters: [String: Any]

    public init(id: Recommendation.Identifier, _ additions: Recommendation.Identifier...,
        locale: Locale? = nil, limit: Int? = nil, offset: Int? = nil) {
        self.init(ids: [id] + additions, locale: locale, limit: limit, offset: offset)
    }

    public init(ids: [Recommendation.Identifier], locale: Locale? = nil, limit: Int? = nil, offset: Int? = nil) {
        self.init(path: "/v1/me/recommendations",
                  parameters: ["ids": makeIds(ids), "l": locale?.languageTag, "limit": limit, "offset": offset].cleaned)
    }

    public init(path: String, parameters: [String: Any]) {
        self.path = path
        _parameters = parameters
        (limit, offset) = parsePaginatorParameters(parameters)
    }
}
