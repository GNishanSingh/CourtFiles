# Installation
 - open powershell on windows 10 and later with admin permission. run following command
 ```powershell
 install-module ImportExcel
 ```
 - Download this folder on some folder. Then run following command
 ```powershell
 import-module <# This folder download location + ReadCourtFile.ps1 #>
 ```
## Usage
```powershell
HPCaseFile -causelistpath <# causelist pdf file location #> -outpath <# path for excel file #> -HeaderPattern <# pattern want to match for pages. e.g. Court - 1 or Court\s+-\s+1 #>
```