using namespace System.Reflection

$p = (get-item -Path ".\").FullName
echo $p

[Assembly]::LoadFrom("$p\bin\DocumentFormat.OpenXml.dll")

$ModifiedBy = "yamada"

<#
#>

function Set-PackageProperties($path, $output){
    $base = pwd
    $release = $output

    $list = Get-ChildItem $path -Recurse -incdude "*.xlsx", "*.docx"
    foreach($item in $list){
        $outPath = Join-Path $base $release
        $outFile = Join-Path $outPath $item.name

        #出力フォルダの作成
        $parent = Split-Path $outFile -Parent
        if(test-path $parent){
        }else{
            new-item $parent -ItemType Directory
        }

        if($item.extention -eq ".docx"){
            $doc = [DocumentFormat.OpenXML.Packageing.WordprocessingDocument]::open($item,$true)
        }else{
            $doc = [DocumentFormat.OpenXML.Packageing.SpreadsheetDocument]::open($item,$true)
        }

        $doc.PackageProperties.LastModifiedBy = $ModifiedBy
        $doc.saveas($outFile)
        $doc.dispose()
    }
}

<#
#>
$scriptName = $MyInvocation.ScriptName
write-host $scriptName
if($scriptName -eq ""){
    if($args.Length -eq 2){
        Set-PackageProperties $args[0] $args[1]
    }else{
        Set-PackageProperties "" ""
    }
}
