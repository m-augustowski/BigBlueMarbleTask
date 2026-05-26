## Requirements Covered

- Swift, SwiftUI and Swift Concurrency.
- Minimum platform: tvOS 26.
- Multiple movie sections loaded from different TMDB endpoints.
- Different card sizes per section.
- Loading, empty and error states for each section.
- Retry support for failed requests.
- tvOS focus handling with focused cards and focus-safe movie identities.
- Paginated category detail screen with incremental loading.

## Architecture

The project is split into four main areas:

- `Models` contains app-level domain models such as `Movie`, `MoviePage` and `MovieCategory`.
- `Networking` contains the client, provider, endpoint, errors and secrets access.
- `Networking/TMDBC` contains the TMDB-specific adapter and DTOs.
- `UI` contains SwiftUI views and view models.

The app uses an MVVM-style structure. Views own layout, navigation and focus state. View models own loading state and async interactions with the movie client. Networking is hidden behind `MovieClientProtocol`, so UI code does not depend directly on TMDB response models.

## Networking

`MovieClientProtocol` defines the app-facing contract:

```swift
func fetchGenres() async throws
func fetchMovies(by category: MovieCategory, page: Int) async throws -> MoviePage
```

`TMDBClient` is the concrete implementation for The Movie Database. It maps TMDB DTOs into app models and keeps TMDB-specific details, such as endpoint paths, bearer token authorization and image URL construction, outside the UI layer.

## Model Identity

`Movie.id` is a local `UUID` used by SwiftUI and the tvOS focus engine. This avoids focus collisions when the same upstream movie appears in more than one category.

`Movie.providerID` stores the stable movie identifier from the current provider. It is intentionally named generically instead of `tmdbID`, because the app model should remain open for expansion. The value is used for deduplicating paginated results.

## UI Flow

`HomeView` shows the main movie sections:

- Popular
- Now Playing
- Upcoming

Each section owns its own loading, empty, ready and error state through `MovieSectionState`. A trailing `Show All` button navigates to `AllMoviesView` for the selected category.

`AllMoviesView` loads the first page for a category and asks `AllMoviesViewModel` to load the next page when the last visible movie appears. Existing movies remain visible if a later page fails, and the user can retry loading.

## Focus and tvOS UX

The UI uses SwiftUI focus APIs:

- `@FocusState` tracks the focused movie card.
- Movie cards are explicitly `.focusable(true)`.
- Focused cards scale and reveal the play button.
- The full category screen includes a visible Back button for remote-friendly navigation.

The main screen also preserves section position when retrying a failed section, so focus does not unexpectedly jump back to the top while the section transitions through loading.

## Configuration

Create `BigBlueMarbleTask/Config/Secrets.xcconfig` from the template:

```text
TMDB_API_TOKEN = "YOUR_TMDB_READ_ACCESS_TOKEN"
```

The token is read through `SecretsProvider` from the app bundle using the `TMDB_API_TOKEN` Info.plist key.

`Secrets.xcconfig` should contain a TMDB API Read Access Token, not the short API key.

## Testability

The networking boundary is expressed through `MovieClientProtocol`, which allows view models to be tested with a mock movie client instead of the live TMDB API.
