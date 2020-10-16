# Star Wars iOS Client App, People Search

The App searches and displays characters.
The App is designed to easily add a search for any type of objects and load details for any type of object (details in [architecture](#Architecture)).

The focus was made on the Core of the App to expand easily, not only UI. UI is primitive but complete for Character search and display.

# Architecture

## Model

Currently only `Character` from */api/people* is supported, all other types of objects are decoded to `Object`, which has only `name` property.
Responses for `search` and `load an object` APIs are stored in a cache.

### Add New Object Type

If you need more properties to display for any objects, similar to `Character`:
1. Create a new class, inherit it from Object. `Character` is an example.
2. Add the object parser call to `Object.decodeToObjectWith`.
The object will be parsed automatically when loaded.

### Add New Search Type

If you need to add a search for a new object type, similar to `Character` in people:
1. Add [New Object Type](#New-Object-Type).
2. Create a new Search class and define searchURL. `CharacterSearch` is an example.

### Endpoint

If [swapi.dev](https://swapi.dev) unavailable, you can use another server, for example [binxhealth/swapi](https://github.com/binxhealth/swapi.git).
To change the server endpoint, update `server_url` in `Info.plist`.

**App Transport Security Settings => Allow Arbitrary Loads=YES** was added to `Info.plist` to support HTTP. Remove it for a release version.

## UI

All UI is implemented using storyboard, xib, and autolayouts without diving into presentation details on specific devices in different rotations.

### CharactersTableViewController

* Initially loads results for `""` empty string;
* Displays all cells at once, and load new pages as user scrolls down;
* Opens `CharacterDetailsViewController` on a cell touch.

### CharacterDetailsViewController

* Displays details info for `Character`;
* Loads all objects by url to display their names (in current version, names only).

# Unit Tests

Ony Core of the App, Data Model and Api Requests, is covered with essential basic tests for successful scenarios.

`CMD + U` to run.


# TODO

* Search Api loads complete objects. Each object can be stored right to `ObjectLoader` cache, to prevent redundant requests to get them.
* Remove **App Transport Security Settings => Allow Arbitrary Loads=YES** for a release version. See [Endpoint](#Endpoint) section for details.
* Verify Dark Mode support.
* Verify UI with different system font sizes, layouts, and devices.
* Show error in case of network or other issues; ability to re-search in case of error.
* Detailed view for each type of object: Planet, Vehicle, etc.
* Clickable names for Planet, Vehicle, etc.
* Search for any type of objects, not only Characters.
* Let users copy all texts.
* Collection View instead of Table View with adjusted layouts for different devices and orientations.
* Unit Tests to cover all code base, not just main use cases with successful paths.
* UI Unit Tests.
* UI functional tests.
* App automation for build and release.
* Integrate App Crash reporting tool.
* Integrate App Usage analytics tool.
* Cache on disk for search & objects.
* Cancel Search and load objects request if they are not needed anymore.
* Localization.
* Show last search result or suggestion on app launch.
* Search history.
