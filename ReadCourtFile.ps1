$presentpath = Split-Path $MyInvocation.MyCommand.path
[System.Reflection.Assembly]::LoadFrom("$presentpath\itextsharp.dll") | Out-Null
function readpdf ($filepath) {
    $file = [iTextSharp.text.pdf.PdfReader]::new($filepath)
    1..$file.NumberOfPages | ForEach-Object {
        [pscustomobject]@{
            PageNo   = $_
            PageText = [iTextSharp.text.pdf.parser.PdfTextExtractor]::GetTextFromPage($file, $_, [iTextSharp.text.pdf.parser.SimpleTextExtractionStrategy]::new())
        }
    }
}

function HPCaseFiles ($causelistpath, $outpath, $HeaderPattern) {
    $casedata = readpdf -filepath $causelistpath | Where-Object { $_.pagetext -match $HeaderPattern } | ForEach-Object { 
        ($_.pagetext | Select-String -Pattern "\w+\s+\d+\/\d+" -AllMatches).Matches.Value | ForEach-Object {
            if (![string]::IsNullOrWhiteSpace($_)) {
                [pscustomobject]@{
                    CaseCode = $_; 
                    Filename = Join-Path $pwd.path (($_ -replace '\W', '_') + '.pdf') 
                } 
            }
        } 
    } 
    if ($outpath) {
        $casedata | Export-Excel $output
    }
    else {
        $casedata
    }
}