# Installation
 - Download this folder on windows 10 and later. Then run following command
 ```powershell
 import-module <# This folder download location + ReadCourtFile.ps1 #>
 ```
## Usage
 - Run below Command in folder contains CourtFiles
```powershell
CD <# Folder path which contains court files #>
HPCaseFiles -causelistpath <# causelist pdf file location #> -outpath <# path for pdf file #> -HeaderPattern <# pattern want to match for pages. e.g. Court - 1 or Court\s+-\s+1 #>
```