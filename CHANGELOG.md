# Changelog

## [Unreleased] - 2025-06-27

### Added
- Added a workspace file with PowerShell code formatting rules
- Added `.vscode\PSScriptAnalyzerSettings.psd1` with the syntax/rules used
- Added `.editorconfig`
- Added `WindowsPowerShell\Variable.ps1` completer
- Added Variable completers to `ArgumentCompleters.csv`
- Added completion for `-Parameter` for `Get-Help`
- Added `Shared\ItemProperty.ps1` completion for `-Name` when the path is a registry key
- Added `Shared\CimInstance.ps1` completion for `-QueryDialect`

### Changed
- Re-formatted `Release notes.txt` to a properly formatted Changelog using the [keepachangelog.com](https://keepachangelog.com) standards
- Modified `WindowsPowerShell\AdProperties.ps1` to use parameter=description hashtables for the completion tooltip
- Modified `WindowsPowerShell\Variable.ps1` to include 0, 1, 2 for `-Scope` along with Local, Global, etc.
- Moved ConfigurationManager to `MECM` folder and modified the list of supported cmdlets. **WIP**
- Modified a few things in `WindowsPowerShell\Help.ps1`

## [1.0.13] - 2025-04-22

### Added
- Add completer for the -Module parameter in Update-Help and Save-Help for Windows PowerShell
- Add completer for the -Source parameter in numerous Microsoft.WinGet.Client cmdlets

## [1.0.12] - 2024-02-16

### Added
- Add completers for Set-TimeZone
- Add completers for the Name parameter for the *PSSessionConfiguration commands

## [1.0.11] - 2023-10-26

### Added
- Add Name, SID and Member completers for *-LocalGroup* commands

### Changed
- Replace "StartsWith" across all completers with "-like" so wildcards in the input text are respected.

## [1.0.10] - 2022-09-22

### Added
- Add completer for New-WinEvent
- Add PSRepository completer
- Add completer for Get-Command and Get-Verb
- Add Volume completer
- Add Disk completer

### Changed
- Update completer for Get-WinEvent to no longer force a wildcard before the input text

### Fixed
- Fix the parameter help for Get-UsefulArgumentCompleter

## [1.0.9] - 2022-09-08

### Fixed
- Fix argument completer for Get-UsefulArgumentCompleter so it properly uses partial input to filter the results.

## [1.0.8] - 2022-09-08

### Added
- Add optional HyperV VMName and ID completers.
- Add Get-UsefulArgumentCompleter command which allows the user to view the available argument completers.
- Add Import-UsefulArgumentCompleterSet command which allows the user to load argument completers that are optional.

## [1.0.7] - 2022-09-06

### Added
- Add language completer for LanguagePackManagement commands
- Add GeoID completer for Set-WinHomeLocation

### Changed
- Include Invariant language in cultureinfo results if input text matches the displayname.

## [1.0.6] - 2022-09-06

### Added
- Add RDP to the port completers for the firewall commands and Test-NetConnection.

### Changed
- Update the list item text for the GptType argument completer for New-Partition to show the friendlyname instead of the GUID.

## [1.0.5] - 2022-09-04

### Fixed
- Fix RemotePort parameter completion for Get-NetTCPConnection

## [1.0.4] - 2022-09-04

### Added
- Add process, port and address completers for Get-NetTCPConnection

## [1.0.3] - 2022-09-02

### Added
- Add Verb completer for Start-Process

## [1.0.2] - 2022-08-22

### Added
- Add cultureinfo and appx argument completers

## [1.0.1] - 2022-08-19

### Fixed
- Fix issue when commands used in the cache were unavailable, or otherwise failed.

## [1.0] - 2022-08-19

### Added
- Initial release with over 30 completers!

# TODO

- [ ] Figure out how to programatically trigger parameter completions for testing
  - [ ] Write Pester tests for each parameter (at least verifying it exists and perhaps the total count?)
- [ ] Separate new files / change groups into branches for simple PRs to the upstream
