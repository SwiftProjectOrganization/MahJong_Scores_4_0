# MahJong Scores API Integration

This directory contains the OpenAPI specification and client code for syncing tournaments with a Vapor backend server.

## Overview

The MahJong Scores app now supports uploading tournament data to a backend server using JSON format and SwiftOpenAPI. This allows you to:

- Back up tournament data to a remote server
- Share tournaments across multiple devices
- Archive completed tournaments
- Export data for analysis

## Architecture

### Data Transfer Objects (DTOs)

Located in `Model/DTO/TournamentDTO.swift`:

- **TournamentDTO**: JSON-serializable version of the Tournament model
- **ScoreDTO**: JSON-serializable version of score data
- **Extension on Tournament**: `toDTO()` method converts SwiftData models to DTOs

These DTOs are Codable and can be easily serialized to/from JSON.

### API Client

Located in `API/TournamentAPIService.swift`:

The `TournamentAPIService` class provides methods to interact with the backend:

```swift
// Initialize with server URL
let service = TournamentAPIService(serverURL: "http://localhost:8080")

// Upload a tournament
let dto = tournament.toDTO()
let uploaded = try await service.uploadTournament(dto)

// List all tournaments
let tournaments = try await service.listTournaments()

// Get a specific tournament
let tournament = try await service.getTournament(id: uuid)

// Update a tournament
let updated = try await service.updateTournament(id: uuid, tournament: dto)

// Delete a tournament
try await service.deleteTournament(id: uuid)
```

### User Interface

Located in `Views/Tournament Views/SyncTournamentView.swift`:

The sync view provides:
- Server URL configuration
- Connection status indicator
- Tournament selection (multi-select)
- Upload progress and status
- Error handling and display

Access the sync view by tapping the sync button (↻) in the toolbar of the main tournaments list.

## OpenAPI Specification

The API is defined in `openapi.yaml` following the OpenAPI 3.0 specification. This file defines:

- API endpoints and operations
- Request/response schemas
- Data types and validation rules

The SwiftOpenAPI Generator plugin automatically creates:
- Type-safe Swift models from the schema
- Client code for making API calls
- Server protocol for implementing the backend

## Configuration

### openapi-generator-config.yaml

```yaml
generate:
  - types      # Generate Swift types from schemas
  - client     # Generate client code
accessModifier: public
```

This configuration tells the SwiftOpenAPI Generator to create both types and client code with public access.

## Usage

### Setting Up the Backend

1. Navigate to the backend directory:
   ```bash
   cd /Users/rob/Projects/Swift/Apps/MahJongScoresBackend
   ```

2. Build and run:
   ```bash
   swift run
   ```

The server starts at `http://localhost:8080`

### Syncing from the iOS App

1. Open the MahJong Scores app
2. From the main tournament list, tap the sync button (↻)
3. Configure the server URL (default: http://localhost:8080)
4. Select tournaments to upload
5. Tap "Upload"
6. Monitor the sync status

### Network Requirements

- The iOS device and backend server must be on the same network (for localhost)
- For remote servers, use a proper domain name or IP address
- Ensure the server URL includes the protocol (http:// or https://)

## Adding Package Dependencies

To use the OpenAPI-generated code, add these dependencies to your Xcode project:

1. Swift OpenAPI Runtime
   - URL: `https://github.com/apple/swift-openapi-runtime`
   - Version: 1.0.0 or later

2. Swift OpenAPI URLSession Transport
   - URL: `https://github.com/apple/swift-openapi-urlsession`
   - Version: 1.0.0 or later

3. Add the OpenAPI Generator plugin to your target:
   - In Xcode, select your target
   - Go to Build Phases > Run Build Tool Plug-ins
   - Add "OpenAPIGenerator" from swift-openapi-generator package

## JSON Format Example

A tournament serialized to JSON looks like:

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "rotateClockwise": true,
  "ruleSet": "INTERNATIONAL",
  "startDate": "2024-03-24 10:30:00",
  "scheduleItem": 0,
  "lastGame": 0,
  "fpName": "Liesbeth",
  "spName": "Rob",
  "tpName": "Nancy",
  "lpName": "Carel",
  "currentWind": "East",
  "players": ["Liesbeth", "Rob", "Nancy", "Carel"],
  "winds": ["East", "South", "West", "North"],
  "fpScores": [
    {
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "name": "Liesbeth",
      "game": 0,
      "score": 2000
    }
  ],
  "spScores": [...],
  "tpScores": [...],
  "lpScores": [...]
}
```

## Security Considerations

For production use, consider:

1. **HTTPS**: Always use HTTPS in production
2. **Authentication**: Add API key or OAuth authentication
3. **Authorization**: Ensure users can only access their own data
4. **Validation**: Validate all input on the server
5. **Rate Limiting**: Prevent abuse with rate limits
6. **Data Privacy**: Comply with privacy regulations (GDPR, etc.)

## Troubleshooting

### Connection Failed

- Verify the server is running
- Check the server URL is correct
- Ensure both devices are on the same network (for localhost)
- Check firewall settings

### Upload Failed

- Check the tournament data is valid
- Review server logs for error details
- Ensure the server has sufficient storage

### Build Errors

- Run `swift package resolve` in both iOS and backend projects
- Clean build folders: `swift package clean` or Xcode > Product > Clean Build Folder
- Verify OpenAPI Generator plugin is properly configured

## Future Enhancements

Potential improvements:

- [ ] Download tournaments from server
- [ ] Conflict resolution for concurrent edits
- [ ] Offline queue for uploads
- [ ] Background sync
- [ ] Push notifications for tournament updates
- [ ] User authentication and multi-user support
- [ ] Database persistence on server (replacing in-memory storage)
