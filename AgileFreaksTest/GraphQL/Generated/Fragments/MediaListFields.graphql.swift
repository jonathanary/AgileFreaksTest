// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension AniListAPI {
  nonisolated struct MediaListFields: AniListAPI.SelectionSet, Fragment {
    static var fragmentDefinition: StaticString {
      #"fragment MediaListFields on Media { __typename id title { __typename romaji english native } coverImage { __typename extraLarge large medium color } averageScore genres duration }"#
    }

    let __data: DataDict
    init(_dataDict: DataDict) { __data = _dataDict }

    static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Media }
    static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", Int.self),
      .field("title", Title?.self),
      .field("coverImage", CoverImage?.self),
      .field("averageScore", Int?.self),
      .field("genres", [String?]?.self),
      .field("duration", Int?.self),
    ] }
    static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      MediaListFields.self
    ] }

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

    /// Title
    ///
    /// Parent Type: `MediaTitle`
    nonisolated struct Title: AniListAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.MediaTitle }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("romaji", String?.self),
        .field("english", String?.self),
        .field("native", String?.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        MediaListFields.Title.self
      ] }

      /// The romanization of the native language title
      var romaji: String? { __data["romaji"] }
      /// The official english title
      var english: String? { __data["english"] }
      /// Official title in it's native language
      var native: String? { __data["native"] }
    }

    /// CoverImage
    ///
    /// Parent Type: `MediaCoverImage`
    nonisolated struct CoverImage: AniListAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.MediaCoverImage }
      static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("extraLarge", String?.self),
        .field("large", String?.self),
        .field("medium", String?.self),
        .field("color", String?.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        MediaListFields.CoverImage.self
      ] }

      /// The cover image url of the media at its largest size. If this size isn't available, large will be provided instead.
      var extraLarge: String? { __data["extraLarge"] }
      /// The cover image url of the media at a large size
      var large: String? { __data["large"] }
      /// The cover image url of the media at medium size
      var medium: String? { __data["medium"] }
      /// Average #hex color of cover image
      var color: String? { __data["color"] }
    }
  }

}