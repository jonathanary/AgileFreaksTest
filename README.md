# FilmKu - Anime Movie Browser

A SwiftUI iOS 17+ movie browser app built for the Agile Freaks coding challenge. Browse trending and top-rated anime movies powered by the [AniList GraphQL API](https://docs.anilist.co).

## Screenshots

| Home Screen | Detail Screen |
|:-----------:|:-------------:|
| Now Showing (trending) + Popular (top-rated) | Banner, trailer, genres, cast |

## Requirements

- Xcode 15.0+
- iOS 17.0+
- No third-party dependencies

## Build & Run

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/AgileFreaksTest.git
   cd AgileFreaksTest
   ```
2. Open `AgileFreaksTest.xcodeproj` in Xcode.
3. Select an iOS 17+ simulator (e.g. iPhone 16 Pro).
4. Press **Cmd + R** to build and run.

No API keys or additional configuration required -- the AniList GraphQL API is public.

## Architecture

**MVVM** with the iOS 17 `@Observable` macro and a **NavigationStack-based Router** for navigation.

```
AgileFreaksTest/
  App/                  Entry point, TabView + NavigationStack setup
  Navigation/           Router class with Route enum for typed navigation
  Models/               Codable structs for AniList GraphQL responses
  Network/              GraphQLClient (URLSession) + query definitions
  ViewModels/           @Observable view models for Home and Detail screens
  Views/
    Home/               HomeView, NowShowingSection, PopularSection
    Detail/             DetailView, CastSection
    Components/         GenreTag, RatingBadge, PosterCard (shared UI)
  Resources/            Asset catalogs
```

### Key Design Decisions

- **No third-party dependencies**: Pure SwiftUI + URLSession. The GraphQL client is a lightweight actor that posts JSON to `https://graphql.anilist.co` and decodes responses with `Codable`.
- **`@Observable` over `ObservableObject`**: Leverages the iOS 17 Observation framework for cleaner state management without `@Published` wrappers.
- **Incremental home loading**: "Now Showing" and "Popular" are fetched in parallel with `withTaskGroup`. Each section updates as soon as its request finishes, so users see the first list without waiting for the second. Per-section loading placeholders avoid a blank first frame.
- **MainActor view models and router**: `HomeViewModel`, `DetailViewModel`, and `Router` are `@MainActor` so UI state updates stay on the main thread.
- **`actor` for network I/O**: `GraphQLClient` is an actor, ensuring safe concurrent access from async call sites.

### Data Flow

```
View (.task) → ViewModel (async) → GraphQLClient (actor) → AniList API
                    ↓
              View re-renders via @Observable
```

### Navigation

Type-safe routing via `NavigationStack(path:)` + `navigationDestination(for: Route.self)`:

```swift
enum Route: Hashable {
    case detail(mediaId: Int)
}
```

## API

All data comes from the [AniList GraphQL API](https://graphql.anilist.co):

| Screen | Query | Sort |
|--------|-------|------|
| Now Showing | `Page { media(type: ANIME, format: MOVIE, ...) }` | `TRENDING_DESC` |
| Popular | `Page { media(type: ANIME, format: MOVIE, ...) }` | `SCORE_DESC` |
| Detail | `Media(id: $id, type: ANIME)` | N/A |

## Features

- **Home Screen**: Horizontal scrolling "Now Showing" section + vertical "Popular" list with genre tags and duration
- **Detail Screen**: Hero banner with trailer button, rating, genres, length/language info, description, and character cast
- **Error handling**: Full-screen retry when both home sections fail; per-section retry when only one request fails; detail screen retry on load failure
- **Tab bar**: Home, Search (placeholder), Saved (placeholder)
