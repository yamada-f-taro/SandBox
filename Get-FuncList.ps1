$sample = ".\sample.bas"

function Get-FunlcList($file,$reg){
 
    if(!(test-path $file)){
    write-host "no such file."
    return
    } 
    $wk = Get-Content -path $file -Encoding UTF8 -raw  
    $wk = $wk.replace("_`r`n","").replace("_`r","").replace("_`n","")
    
    #$regex = new-object  regex $reg ,("multiline","ignorecase")
    $regex = new-object  regex $reg ,("multiline","ignorecase")
    $regex.Replace($wk,".* "," ")
    $regex.Matches($wk)|ForEach{$_.value}

    write-host "--------"
}

Get-FunlcList $sample "^(private|public) (function|sub).*$|^(function|sub).*$"

#参考：
#https://cheshire-wara.com/powershell/ps-help/select-string-help/
