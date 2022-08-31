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

function Export-PDFTable ($Dataset,$Filepath){
    $fstream = [System.IO.FileStream]::new($Filepath, [System.IO.FileMode]::Create)
    $document = [iTextSharp.text.Document]::new([iTextSharp.text.PageSize]::A5, 25, 25, 30, 30)
    $writer = [iTextSharp.text.pdf.PdfWriter]::GetInstance($document, $fstream)
    $document.Open()
    $table = [iTextSharp.text.pdf.PdfPTable]::new(2)
    ($Dataset | Get-Member -MemberType NoteProperty).Name |ForEach-Object {
        $table.AddCell($_)
    }
    $Dataset | ForEach-Object {
        $table.AddCell($_.CaseCode)
        $cell = [iTextSharp.text.pdf.PdfPCell]::new()
        $font = [iTextSharp.text.FontFactory]::GetFont("Arial", 12, [iTextSharp.text.Font]::UNDERLINE, [iTextSharp.text.BaseColor]::BLUE)
        $text = [iTextSharp.text.Anchor]::new($_.Filename, $font)
        $text.Reference = $_.Filename
        $para = [iTextSharp.text.Paragraph]::new()
        $para.Add($text) | Out-Null
        $cell.AddElement($para) | Out-Null
        $table.AddCell($cell) | Out-Null
    }
    $document.Add($table)
    $document.Close()
    $writer.close()
    $fstream.Close()
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
        if (Export-PDFTable -Dataset $casedata -Filepath $outpath){
            Write-Host "File Generated Successfully $outpath"
        }
    }
    else {
        $casedata
    }
}