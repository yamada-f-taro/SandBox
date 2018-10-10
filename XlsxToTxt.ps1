#Excel VBA モジュールのエクスポート#https://www.kannon.link/free/2015/06/25/excel-vba-module-export/
using namespace System.Reflection

$p = (get-item -Path ".\").FullName
echo $p

[Assembly]::LoadFrom("$p\bin\EPPlus.dll") | Out-Null

<#
#>

function Get-ModuleItem($filePath, $output){
    $excel = New-Object OfficeOpenXml.ExcelPackage -ArgumentList $filePath
    foreach ($module in $excel.Workbook.VbaProject.Modules)
    {
        $ext = "";
        Write-Host $module.Type

        if($module.Type -eq [OfficeOpenXml.VBA.eModuleType]::Module){
            $ext = "bas"
        }elseif($module.Type -eq [OfficeOpenXml.VBA.eModuleType]::Class ){
            $ext = "cls"
        }elseif($module.Type -eq [OfficeOpenXml.VBA.eModuleType]::Designer){
            $ext = "frm"
        }else{
            $ext = "txt"
        }

        if ($ext -ne "")
        {
            if(!(Test-Path $output)){
                new-item $output -ItemType Directory
            }

            $output_file = [string]::Format( "{0}\{1}.{2}", $output, $module.Name, $ext)
            $module.code | Out-File $output_file
        }
    }
    $excel.Save()
    $excel.Dispose() 
}

<#
function Get-ExcelFiles($base,$out){
    $list = Get-ChildItem $path -Recurse -include "*.xlsm", "*.xlsx"
    foreach($item in $list){
        Get-ModuleItem($item,$out)
    }
}
#>

$scriptName = $MyInvocation.ScriptName
write-host $scriptName
if($scriptName -eq ""){
    if($args.Length -eq 2){
        Get-ModuleItem $args[0] $args[1]
    }else{
        Get-ModuleItem ".\book1.xlsm" ".\out\"
    }
}


<#
$scriptName = $MyInvocation.ScriptName
write-host $scriptName
if($scriptName -eq ""){
    if($args.Length -eq 2){
        Get-ExcelFiles $args[0] $args[1]
    }else{
        Get-ExcelFiles ".\" ".\out\"
    }
}
#>
