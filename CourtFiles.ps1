########## Reading PDF ###########
$presentpath = Split-Path $MyInvocation.MyCommand.path
[System.Reflection.Assembly]::LoadFrom("$presentpath\itextsharp.dll") | Out-Null
function Get-CourtFiles (
    $SourceFile,
    $FromPageNo,
    $ToPageNo
) {
    $FromPageNo..$ToPageNo | ForEach-Object {
        $file = [iTextSharp.text.pdf.PdfReader]::new($SourceFile)
        $text = [iTextSharp.text.pdf.parser.PdfTextExtractor]::GetTextFromPage($file, $_, [iTextSharp.text.pdf.parser.SimpleTextExtractionStrategy]::new())
        $text.Split("`n") | Where-Object { $_ -match "(LPA|LPAC|LPAHC|LPAIT|LPAOW|LPAST|LPASW|LPPIL|LSC|OSA|OSMA|AA|CRA|CRAA|CRREF|PIL|ITA|ETA|CEA|ITR|STR|CER|CDR|OWP|MA|SWP|RP|RPOWP|RPPIL|RPSW|CTP|CPC|CPCOS|CPLPA|CPOWP|CPSSW|CPSW|CPCR|RESCR|RCPIL|RESC|RES|RESAA|RESLP|RESOW|MCC|CRMC|SLA|CDLSW|CDLOW|CONC|CD|CDLHC|CONIL|CONCR|TP|REF|SWP|OWP|CRA|CRAA|CFA|LCROS|CSA|MA|BA|HCP|AP|AA|CTA|CRTA|CRMC|CTP|CPC|CPOWP|CPSW|CREF|CRREF|EXP|CR|CRR|CP|OS|EXA|RP|RP104|RPAA|RPC|RPCR|RPHCP|RPLPA|RPOWP|RPSW|EP|MCC|RESC|RES|RESAA|RESLP|CONC|CD|CONSW|CONCR)\s\d+\/\d+" } | ForEach-Object {
    ($_ | Select-String -Pattern "(LPA|LPAC|LPAHC|LPAIT|LPAOW|LPAST|LPASW|LPPIL|LSC|OSA|OSMA|AA|CRA|CRAA|CRREF|PIL|ITA|ETA|CEA|ITR|STR|CER|CDR|OWP|MA|SWP|RP|RPOWP|RPPIL|RPSW|CTP|CPC|CPCOS|CPLPA|CPOWP|CPSSW|CPSW|CPCR|RESCR|RCPIL|RESC|RES|RESAA|RESLP|RESOW|MCC|CRMC|SLA|CDLSW|CDLOW|CONC|CD|CDLHC|CONIL|CONCR|TP|REF|SWP|OWP|CRA|CRAA|CFA|LCROS|CSA|MA|BA|HCP|AP|AA|CTA|CRTA|CRMC|CTP|CPC|CPOWP|CPSW|CREF|CRREF|EXP|CR|CRR|CP|OS|EXA|RP|RP104|RPAA|RPC|RPCR|RPHCP|RPLPA|RPOWP|RPSW|EP|MCC|RESC|RES|RESAA|RESLP|CONC|CD|CONSW|CONCR)\s\d+\/\d+").Matches.Value
        }
    }
}

function Get-CourtFilePath ($searchstring,$Folderpath){
    Get-ChildItem -path $Folderpath | ForEach-Object {
        if (($_.BaseName -replace "\W",'') -match $searchstring){
            $_.FullName
        }
    }
}