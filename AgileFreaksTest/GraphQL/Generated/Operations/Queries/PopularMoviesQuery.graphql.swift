// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension AniListAPI {
  nonisolated struct PopularMoviesQuery: GraphQLQuery {
    static let operationName: String = "PopularMovies"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query PopularMovies($page: Int, $perPage: Int) { Page(page: $page, perPage: $perPage) { __typename pageInfo { __typename currentPage hasNextPage perPage } media(type: ANIME, format: MOVIE, sort: SCORE_DESC, isAdult: false) { __typename ...MediaListFields bannerImage countryOfOrigin } } }"#,
        fragments: [MediaListFields.self]
      ))

    public var page: GraphQLNullable<Int32>
    public var perPage: GraphQLNullable<Int32>

    public init(
      page: GraphQLNullable<Int32>,
      perPage: GraphQLNullable<Int32>
    ) {
      self.page = page
      self.perPage = perPage
    }

    @_spi(Unsafe) public var __variables: Variables? { [
      "page": page,
      "perPage": perPage
    ] }

    nonisolated struct Data: AniListAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("Page", Page?.self, arguments: [
          "page": .variable("page"),
          "perPage": .variable("perPage")
        ]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        PopularMoviesQuery.Data.self
      ] }

      var page: Page? { __data["Page"] }

      /// Page
      ///
      /// Parent Type: `Page`
      nonisolated struct Page: AniListAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Page }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("pageInfo", PageInfo?.self),
          .field("media", [Medium?]?.self, arguments: [
            "type": "ANIME",
            "format": "MOVIE",
            "sort": "SCORE_DESC",
            "isAdult": false
          ]),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          PopularMoviesQuery.Data.Page.self
        ] }

        /// The pagination information
        var pageInfo: PageInfo? { __data["pageInfo"] }
        var media: [Medium?]? { __data["media"] }

        /// Page.PageInfo
        ///
        /// Parent Type: `PageInfo`
        nonisolated struct PageInfo: AniListAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.PageInfo }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("currentPage", Int?.self),
            .field("hasNextPage", Bool?.self),
            .field("perPage", Int?.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            PopularMoviesQuery.Data.Page.PageInfo.self
          ] }

          /// The current page
          var currentPage: Int? { __data["currentPage"] }
          /// If there is another page
          var hasNextPage: Bool? { __data["hasNextPage"] }
          /// The count on a page
          var perPage: Int? { __data["perPage"] }
        }

        /// Page.Medium
        ///
        /// Parent Type: `Media`
        nonisolated struct Medium: AniListAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Media }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("bannerImage", String?.self),
            .field("countryOfOrigin", AniListAPI.CountryCode?.self),
            .fragment(MediaListFields.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            PopularMoviesQuery.Data.Page.Medium.self,
            MediaListFields.self
          ] }

          /// The banner image of the media
          var bannerImage: String? { __data["bannerImage"] }
          /// Where the media was created. (ISO 3166-1 alpha-2)
          var countryOfOrigin: AniListAPI.CountryCode? { __data["countryOfOrigin"] }
          /// The id of the media
          var id: Int { __data["id"] }
          /// The official titles of the media in various languages
          var title: Title? { __data["title"] }
          /// The cover images of the media
          var coverImage: CoverImage? { __data["coverImage"] }
          /// A weighted average score of all the user's scores of the media
          var averageScore: Int? { __data["averageScore"] }
          /// The genres of the media
          var genres: [String?]? { __data["genres"] }
          /// The general length of each anime episode in minutes
          var duration: Int? { __data["duration"] }

          struct Fragments: FragmentContainer {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            var mediaListFields: MediaListFields { _toFragment() }
          }

          typealias Title = MediaListFields.Title

          typealias CoverImage = MediaListFields.CoverImage
        }
      }
    }
  }

}