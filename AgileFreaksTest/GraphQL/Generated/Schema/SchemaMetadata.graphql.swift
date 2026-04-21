// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

nonisolated protocol AniListAPI_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == AniListAPI.SchemaMetadata {}

nonisolated protocol AniListAPI_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == AniListAPI.SchemaMetadata {}

nonisolated protocol AniListAPI_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == AniListAPI.SchemaMetadata {}

nonisolated protocol AniListAPI_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == AniListAPI.SchemaMetadata {}

extension AniListAPI {
  typealias SelectionSet = AniListAPI_SelectionSet

  typealias InlineFragment = AniListAPI_InlineFragment

  typealias MutableSelectionSet = AniListAPI_MutableSelectionSet

  typealias MutableInlineFragment = AniListAPI_MutableInlineFragment

  nonisolated enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    private static let objectTypeMap: [String: ApolloAPI.Object] = [
      "Character": AniListAPI.Objects.Character,
      "CharacterConnection": AniListAPI.Objects.CharacterConnection,
      "CharacterEdge": AniListAPI.Objects.CharacterEdge,
      "CharacterImage": AniListAPI.Objects.CharacterImage,
      "CharacterName": AniListAPI.Objects.CharacterName,
      "Media": AniListAPI.Objects.Media,
      "MediaCoverImage": AniListAPI.Objects.MediaCoverImage,
      "MediaTitle": AniListAPI.Objects.MediaTitle,
      "MediaTrailer": AniListAPI.Objects.MediaTrailer,
      "Page": AniListAPI.Objects.Page,
      "PageInfo": AniListAPI.Objects.PageInfo,
      "Query": AniListAPI.Objects.Query,
      "Staff": AniListAPI.Objects.Staff,
      "StaffImage": AniListAPI.Objects.StaffImage,
      "StaffName": AniListAPI.Objects.StaffName
    ]

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      objectTypeMap[typename]
    }
  }

  nonisolated enum Objects {}
  nonisolated enum Interfaces {}
  nonisolated enum Unions {}

}