#$sample = ".\sample.bas"
$sample = ".\*\*.bas"

function Get-FunlcList($file,$reg){
 
    if(!(test-path $file)){
    write-host "no such file."
    return
    } 
    $wk = Get-Content -path $file -Encoding UTF8 -raw  
    $wk = $wk.replace("_`r`n","").replace("_`r","").replace("_`n","")
    write-host $wk

<#    
    write-host "--------"
    Select-String -path $file -Pattern "^function |^private function |^public function |^sub |^private sub |public sub" 
#>
    write-host "--------::"
    #$regex=[regex]::new("^function |^private function |^public function |^sub |^private sub |public sub" )
    #$regex= new-object  regex "^function.*$" ,"multiline"
    $regex= new-object  regex "^function.*$" ,"multiline"
    $regex.Matches($wk)|ForEach{$_.value}

    write-host "--------"
}

Get-FunlcList $sample ""

#参考：
#https://cheshire-wara.com/powershell/ps-help/select-string-help/
