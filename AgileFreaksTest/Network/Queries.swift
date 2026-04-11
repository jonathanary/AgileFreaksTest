import Foundation

enum GraphQLQueries {

    static let nowShowingMovies = """
    query ($page: Int, $perPage: Int) {
      Page(page: $page, perPage: $perPage) {
        pageInfo {
          currentPage
          hasNextPage
          perPage
        }
        media(type: ANIME, format: MOVIE, sort: TRENDING_DESC, isAdult: false) {
          id
          title {
            romaji
            english
            native
          }
          coverImage {
            extraLarge
            large
            medium
            color
          }
          averageScore
          genres
          duration
        }
      }
    }
    """

    static let popularMovies = """
    query ($page: Int, $perPage: Int) {
      Page(page: $page, perPage: $perPage) {
        pageInfo {
          currentPage
          hasNextPage
          perPage
        }
        media(type: ANIME, format: MOVIE, sort: SCORE_DESC, isAdult: false) {
          id
          title {
            romaji
            english
            native
          }
          coverImage {
            extraLarge
            large
            medium
            color
          }
          bannerImage
          averageScore
          genres
          duration
          countryOfOrigin
        }
      }
    }
    """

    static let mediaDetail = """
    query ($id: Int!) {
      Media(id: $id, type: ANIME) {
        id
        title {
          romaji
          english
          native
        }
        type
        format
        status
        description(asHtml: false)
        duration
        episodes
        seasonYear
        averageScore
        meanScore
        popularity
        genres
        source
        countryOfOrigin
        coverImage {
          extraLarge
          large
          medium
          color
        }
        bannerImage
        trailer {
          id
          site
          thumbnail
        }
        characters(sort: ROLE, perPage: 10) {
          edges {
            node {
              id
              name {
                full
                native
              }
              image {
                large
                medium
              }
            }
            role
            voiceActors(language: JAPANESE) {
              id
              name {
                full
              }
              image {
                medium
              }
              languageV2
            }
          }
        }
      }
    }
    """
}
