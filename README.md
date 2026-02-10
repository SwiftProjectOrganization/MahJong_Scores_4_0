# MahJong_Scores_4_0.swift

## Purpose

MahJong_Scores_4_0.swift is an iOS application to keep scores of one or more MahJong tournaments.
This project uses CloudKit to sync owner's devices. Version 4 includes support for American rule sets and JSON-based backend synchronization.

A MahJong tournament consists of all four players being the wind players for all 4 winds. Thus in total at least 16 games, but usually more. 

Completion of a tournament can take days, weeks or even much longer. That's why I developed this little app.

## New Features (Version 4.0)

### JSON Export and Backend Synchronization

The app now supports uploading tournament data to a backend server using JSON format and SwiftOpenAPI:

- **Data Transfer Objects (DTOs)**: Convert SwiftData models to JSON-serializable formats
- **API Client**: Type-safe client for communicating with Vapor backend
- **Sync UI**: Select and upload tournaments to a remote server
- **OpenAPI Specification**: Well-defined API contract between client and server

See [API/README.md](API/README.md) for detailed documentation on the API integration.

## Usage

### Creating and Managing Tournaments

Create a tournament by tapping the "+". Select the newly created tournament. All players should have 2000 points. Press "Game completed" and, if necessary, rotate the players and enter the computed scores.

### Syncing to Backend Server

1. Tap the sync button (↻) in the toolbar
2. Configure the server URL (default: http://localhost:8080)
3. Select tournaments to upload
4. Tap "Upload" to sync

For backend setup, see the [MahJongScoresBackend README](https://github.com/SwiftProjectOrganization/MahjongScoresBackend/blob/main/README.md).

## Notes

The "computed scores" are the game results for each player.

## To do

1. Is it useful to keep an overall average player score across tournaments?
2. Develop an easy way to enter the stones for all 4 players at the end of the game and compute the score?
3. Strategy tutorial?
4. Both for traditional and American tournaments?
5. Enter American scoring cards?
