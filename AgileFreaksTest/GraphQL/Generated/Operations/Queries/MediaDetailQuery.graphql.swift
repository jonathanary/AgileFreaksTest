// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension AniListAPI {
  nonisolated struct MediaDetailQuery: GraphQLQuery {
    static let operationName: String = "MediaDetail"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query MediaDetail($id: Int!) { Media(id: $id, type: ANIME) { __typename id title { __typename romaji english native } type format status description(asHtml: false) duration episodes seasonYear averageScore meanScore popularity genres source countryOfOrigin coverImage { __typename extraLarge large medium color } bannerImage trailer { __typename id site thumbnail } characters(sort: ROLE, perPage: 10) { __typename edges { __typename node { __typename id name { __typename full native } image { __typename large medium } } role voiceActors(language: JAPANESE) { __typename id name { __typename full } image { __typename medium } languageV2 } } } } }"#
      ))

    public var id: Int32

    public init(id: Int32) {
      self.id = id
    }

    @_spi(Unsafe) public var __variables: Variables? { ["id": id] }

    nonisolated struct Data: AniListAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("Media", Media?.self, arguments: [
          "id": .variable("id"),
          "type": "ANIME"
        ]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        MediaDetailQuery.Data.self
      ] }

      /// Media query
      var media: Media? { __data["Media"] }

      /// Media
      ///
      /// Parent Type: `Media`
      nonisolated struct Media: AniListAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Media }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Int.self),
          .field("title", Title?.self),
          .field("type", GraphQLEnum<AniListAPI.MediaType>?.self),
          .field("format", GraphQLEnum<AniListAPI.MediaFormat>?.self),
          .field("status", GraphQLEnum<AniListAPI.MediaStatus>?.self),
          .field("description", String?.self, arguments: ["asHtml": false]),
          .field("duration", Int?.self),
          .field("episodes", Int?.self),
          .field("seasonYear", Int?.self),
          .field("averageScore", Int?.self),
          .field("meanScore", Int?.self),
          .field("popularity", Int?.self),
          .field("genres", [String?]?.self),
          .field("source", GraphQLEnum<AniListAPI.MediaSource>?.self),
          .field("countryOfOrigin", AniListAPI.CountryCode?.self),
          .field("coverImage", CoverImage?.self),
          .field("bannerImage", String?.self),
          .field("trailer", Trailer?.self),
          .field("characters", Characters?.self, arguments: [
            "sort": "ROLE",
            "perPage": 10
          ]),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          MediaDetailQuery.Data.Media.self
        ] }

        /// The id of the media
        var id: Int { __data["id"] }
        /// The official titles of the media in various languages
        var title: Title? { __data["title"] }
        /// The type of the media; anime or manga
        var type: GraphQLEnum<AniListAPI.MediaType>? { __data["type"] }
        /// The format the media was released in
        var format: GraphQLEnum<AniListAPI.MediaFormat>? { __data["format"] }
        /// The current releasing status of the media
        var status: GraphQLEnum<AniListAPI.MediaStatus>? { __data["status"] }
        /// Short description of the media's story and characters
        var description: String? { __data["description"] }
        /// The general length of each anime episode in minutes
        var duration: Int? { __data["duration"] }
        /// The amount of episodes the anime has when complete
        var episodes: Int? { __data["episodes"] }
        /// The season year the media was initially released in
        var seasonYear: Int? { __data["seasonYear"] }
        /// A weighted average score of all the user's scores of the media
        var averageScore: Int? { __data["averageScore"] }
        /// Mean score of all the user's scores of the media
        var meanScore: Int? { __data["meanScore"] }
        /// The number of users with the media on their list
        var popularity: Int? { __data["popularity"] }
        /// The genres of the media
        var genres: [String?]? { __data["genres"] }
        /// Source type the media was adapted from.
        var source: GraphQLEnum<AniListAPI.MediaSource>? { __data["source"] }
        /// Where the media was created. (ISO 3166-1 alpha-2)
        var countryOfOrigin: AniListAPI.CountryCode? { __data["countryOfOrigin"] }
        /// The cover images of the media
        var coverImage: CoverImage? { __data["coverImage"] }
        /// The banner image of the media
        var bannerImage: String? { __data["bannerImage"] }
        /// Media trailer or advertisement
        var trailer: Trailer? { __data["trailer"] }
        /// The characters in the media
        var characters: Characters? { __data["characters"] }

        /// Media.Title
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
            MediaDetailQuery.Data.Media.Title.self
          ] }

          /// The romanization of the native language title
          var romaji: String? { __data["romaji"] }
          /// The official english title
          var english: String? { __data["english"] }
          /// Official title in it's native language
          var native: String? { __data["native"] }
        }

        /// Media.CoverImage
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
            MediaDetailQuery.Data.Media.CoverImage.self
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

        /// Media.Trailer
        ///
        /// Parent Type: `MediaTrailer`
        nonisolated struct Trailer: AniListAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.MediaTrailer }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", String?.self),
            .field("site", String?.self),
            .field("thumbnail", String?.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            MediaDetailQuery.Data.Media.Trailer.self
          ] }

          /// The trailer video id
          var id: String? { __data["id"] }
          /// The site the video is hosted by (Currently either youtube or dailymotion)
          var site: String? { __data["site"] }
          /// The url for the thumbnail image of the video
          var thumbnail: String? { __data["thumbnail"] }
        }

        /// Media.Characters
        ///
        /// Parent Type: `CharacterConnection`
        nonisolated struct Characters: AniListAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.CharacterConnection }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("edges", [Edge?]?.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            MediaDetailQuery.Data.Media.Characters.self
          ] }

          var edges: [Edge?]? { __data["edges"] }

          /// Media.Characters.Edge
          ///
          /// Parent Type: `CharacterEdge`
          nonisolated struct Edge: AniListAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.CharacterEdge }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("node", Node?.self),
              .field("role", GraphQLEnum<AniListAPI.CharacterRole>?.self),
              .field("voiceActors", [VoiceActor?]?.self, arguments: ["language": "JAPANESE"]),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              MediaDetailQuery.Data.Media.Characters.Edge.self
            ] }

            var node: Node? { __data["node"] }
            /// The characters role in the media
            var role: GraphQLEnum<AniListAPI.CharacterRole>? { __data["role"] }
            /// The voice actors of the character
            var voiceActors: [VoiceActor?]? { __data["voiceActors"] }

            /// Media.Characters.Edge.Node
            ///
            /// Parent Type: `Character`
            nonisolated struct Node: AniListAPI.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Character }
              static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("id", Int.self),
                .field("name", Name?.self),
                .field("image", Image?.self),
              ] }
              static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                MediaDetailQuery.Data.Media.Characters.Edge.Node.self
              ] }

              /// The id of the character
              var id: Int { __data["id"] }
              /// The names of the character
              var name: Name? { __data["name"] }
              /// Character images
              var image: Image? { __data["image"] }

              /// Media.Characters.Edge.Node.Name
              ///
              /// Parent Type: `CharacterName`
              nonisolated struct Name: AniListAPI.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.CharacterName }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("full", String?.self),
                  .field("native", String?.self),
                ] }
                static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                  MediaDetailQuery.Data.Media.Characters.Edge.Node.Name.self
                ] }

                /// The character's first and last name
                var full: String? { __data["full"] }
                /// The character's full name in their native language
                var native: String? { __data["native"] }
              }

              /// Media.Characters.Edge.Node.Image
              ///
              /// Parent Type: `CharacterImage`
              nonisolated struct Image: AniListAPI.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.CharacterImage }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("large", String?.self),
                  .field("medium", String?.self),
                ] }
                static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                  MediaDetailQuery.Data.Media.Characters.Edge.Node.Image.self
                ] }

                /// The character's image of media at its largest size
                var large: String? { __data["large"] }
                /// The character's image of media at medium size
                var medium: String? { __data["medium"] }
              }
            }

            /// Media.Characters.Edge.VoiceActor
            ///
            /// Parent Type: `Staff`
            nonisolated struct VoiceActor: AniListAPI.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.Staff }
              static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("id", Int.self),
                .field("name", Name?.self),
                .field("image", Image?.self),
                .field("languageV2", String?.self),
              ] }
              static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                MediaDetailQuery.Data.Media.Characters.Edge.VoiceActor.self
              ] }

              /// The id of the staff member
              var id: Int { __data["id"] }
              /// The names of the staff member
              var name: Name? { __data["name"] }
              /// The staff images
              var image: Image? { __data["image"] }
              /// The primary language of the staff member. Current values: Japanese, English, Korean, Italian, Spanish, Portuguese, French, German, Hebrew, Hungarian, Chinese, Arabic, Filipino, Catalan, Finnish, Turkish, Dutch, Swedish, Thai, Tagalog, Malaysian, Indonesian, Vietnamese, Nepali, Hindi, Urdu
              var languageV2: String? { __data["languageV2"] }

              /// Media.Characters.Edge.VoiceActor.Name
              ///
              /// Parent Type: `StaffName`
              nonisolated struct Name: AniListAPI.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.StaffName }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("full", String?.self),
                ] }
                static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                  MediaDetailQuery.Data.Media.Characters.Edge.VoiceActor.Name.self
                ] }

                /// The person's first and last name
                var full: String? { __data["full"] }
              }

              /// Media.Characters.Edge.VoiceActor.Image
              ///
              /// Parent Type: `StaffImage`
              nonisolated struct Image: AniListAPI.SelectionSet {
                let __data: DataDict
                init(_dataDict: DataDict) { __data = _dataDict }

                static var __parentType: any ApolloAPI.ParentType { AniListAPI.Objects.StaffImage }
                static var __selections: [ApolloAPI.Selection] { [
                  .field("__typename", String.self),
                  .field("medium", String?.self),
                ] }
                static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                  MediaDetailQuery.Data.Media.Characters.Edge.VoiceActor.Image.self
                ] }

                /// The person's image of media at medium size
                var medium: String? { __data["medium"] }
              }
            }
          }
        }
      }
    }
  }

}