# FilmKu — Anime Movie Browser

A SwiftUI iOS 17+ movie browser app built for the Agile Freaks coding challenge. Browse trending and top-rated anime movies powered by the [AniList GraphQL API](https://docs.anilist.co).

## Screenshots

| Home Screen | Detail Screen |
|:-----------:|:-------------:|
| <img width="206" height="422" alt="image" src="https://github.com/user-attachments/assets/87d753db-9194-4de3-bf94-232f2a6a0c5d" />| <img width="206" height="422" alt="image" src="https://github.com/user-attachments/assets/0fbf7c79-3df4-437c-b2f6-e9a1b38620cd" />

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

No API keys or additional configuration required — the AniList GraphQL API is public.

### Running Tests

Press **Cmd + U** in Xcode, or from the terminal:

```bash
xcodebuild test \
  -project AgileFreaksTest.xcodeproj \
  -scheme AgileFreaksTest \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

The test suite uses the **Swift Testing** framework (`import Testing`) with 50 tests covering domain logic, repository, view models, networking, and navigation.

### Linting (optional)

Install [SwiftLint](https://github.com/realm/SwiftLint) via Homebrew (`brew install swiftlint`) and run from the repo root:

```bash
swiftlint lint
```

A SwiftLint build phase runs automatically in Xcode (advisory — does not fail the build). User Script Sandboxing is disabled so SwiftLint can read sources.

## Architecture

**Clean Architecture** with MVVM presentation layer, the iOS 17 `@Observable` macro, and a **NavigationStack-based Router**.

```
AgileFreaksTest/
  App/                  Entry point, DesignSystem, AppColors, Logger
  Navigation/           Router + Route enum for typed navigation
  Domain/               Movie, CastMember (domain models + mocks)
  Models/               Media DTO, nested Decodable structs (GraphQL response types)
  Repositories/         MediaRepositoryProtocol, MediaRepository, MediaMapper
  Network/              GraphQLClientProtocol, GraphQLClient (actor), Queries, NetworkError
  ViewModels/           HomeViewModel, DetailViewModel (@Observable)
  Views/
    Home/               HomeView, NowShowingSection, PopularSection
    Detail/             DetailView, CastSection
    Components/         PosterCard, RatingBadge, GenreTag, SectionHeaderRow,
                        RemoteImage, SectionErrorView, SkeletonRect

AgileFreaksTestTests/
  Domain/               MediaMapperTests, MediaTrailerTests
  Repositories/         MediaRepositoryTests
  ViewModels/           HomeViewModelTests, DetailViewModelTests
  Network/              NetworkErrorTests
  Navigation/           RouterTests
  Mocks/                MockGraphQLClient, MockMediaRepository
```

### Layer Diagram

```
View  →  ViewModel  →  Repository (protocol)  →  GraphQLClient (protocol)
                              ↓                          ↓
                        MediaMapper              URLSession + AniList API
                     (DTO → Domain)
```

- **Domain layer** (`Movie`, `CastMember`) — pure value types, no framework imports, no optionals where avoidable. Pre-computed display fields (formatted duration, score, language, cleaned description).
- **Repository layer** (`MediaRepository`) — owns GraphQL query strings, calls `GraphQLClientProtocol`, maps `Media` DTOs to `Movie` domain models via `MediaMapper`.
- **Network layer** (`GraphQLClient`) — a lightweight `actor` that posts JSON to `https://graphql.anilist.co` and decodes `Codable` responses. Protocol-abstracted for testability.
- **Presentation layer** — `@Observable` ViewModels injected with repository protocol. Views are stateless consumers of domain types.
- **Design System** (`DesignSystem.swift`, `AppColors.swift`) — centralized spacing, corner radii, shadows, sizing, typography, and semantic color tokens. Zero magic numbers in views.

### Key Design Decisions

- **No third-party dependencies**: Pure SwiftUI + URLSession.
- **Protocol-driven DI**: `GraphQLClientProtocol` and `MediaRepositoryProtocol` allow full mock injection in tests — no singletons in test paths.
- **DTO ↔ Domain split**: `Media` (Decodable DTO) is never exposed to Views. `MediaMapper` handles all formatting, fallback chains, and HTML stripping. This isolates API changes from the UI.
- **Generalized pagination**: `HomeViewModel` uses a single generic `loadSection`/`loadMore` pattern instead of duplicated per-section methods.
- **Shared UI components**: `RemoteImage`, `SectionErrorView`, `SkeletonRect`, and `SectionHeaderRow` eliminate repeated view patterns.
- **`@Observable` over `ObservableObject`**: Leverages the iOS 17 Observation framework for cleaner state management without `@Published`.
- **`actor` for network I/O**: `GraphQLClient` is an actor, ensuring safe concurrent access.
- **Incremental home loading**: "Now Showing" and "Popular" are fetched in parallel with `withTaskGroup`. Each section updates independently.
- **Swift Testing**: Test suite uses `@Suite`, `@Test`, `#expect`, and parameterized tests instead of XCTest.

## API

All data comes from the [AniList GraphQL API](https://graphql.anilist.co):

| Screen | Query | Sort |
|--------|-------|------|
| Now Showing | `Page { media(type: ANIME, format: MOVIE, ...) }` | `TRENDING_DESC` |
| Popular | `Page { media(type: ANIME, format: MOVIE, ...) }` | `SCORE_DESC` |
| Detail | `Media(id: $id, type: ANIME)` | N/A |

## Features

- **Home Screen**: Horizontal scrolling "Now Showing" section + vertical "Popular" list with genre tags and duration
- **Detail Screen**: Hero banner with trailer button, rating, genres, length/language/format info, description, and character cast
- **Error handling**: Full-screen retry when both home sections fail; per-section retry when only one fails; detail screen retry on load failure
- **Skeleton loaders**: Section-specific loading placeholders for both Now Showing and Popular
- **Accessibility**: VoiceOver labels on all interactive elements, genre tags, rating badges, and cast cards
- **Design System**: Centralized tokens for spacing, radii, shadows, sizing, typography, and colors
- **Tab bar**: Home, Search (placeholder), Saved (placeholder)
