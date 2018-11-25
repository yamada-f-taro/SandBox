$toolpath = "C:\Users\yamada\Documents\project\sandbox\praltUML\plantuml.jar"
$path = "C:\Users\yamada\Documents\project\sandbox\praltUML\*.*"
$outFile = "C:\Users\yamada\Documents\project\sandbox\praltUML\output.pu"

$mystack = new-object system.collections.stack

<#
@startuml sample.png
@enduml
#>

function main(){

    $lines = @()
    $funcs = @()

    $files = get-childitem $path -include "*.bas"

    foreach ($file in $files){
        Get-Content $file.fullname | Foreach-Object {
            $line = $_.trim()

            #全行格納配列
            if($line -ne ""){
                $lines += $line

                #関数名の配列を作成
                $wk = MyTrim $line

                #関数名の配列を作成
                if ($line -ne $wk) {
                    $funcs += $wk
                }
            }
        }

        for($idx=0; $idx -lt $lines.Count; $idx++) {
            $flg = $false
            
            if(isEndFunc($lines[$idx])){
                continue
            }

            foreach ($func in $funcs){
                #if($lines[$idx].IndexOf($func) -ne -1){
                if(isFunc  $lines[$idx] $func ){
                    $flg = $true
                    break
                }
            }
            if($flg -eq $false){
                $lines[$idx] = $null
            }
        }
        <#
        @startuml sample.png
        @enduml
        #>

        #きたっぽい
        "@startuml sample.png" | Out-File -FilePath $outFile -Encoding utf8
        write-uml $lines "autorun"
        "@enduml" | Out-File -FilePath $outFile  -Append -Encoding utf8
    }
}

#privateなどを取り除く
function MyTrim($line){
    $wk = $line
    $flg = $false
    if ([String]::IsNullOrEmpty($wk) -eq $false){
        if($wk.ToLower().StartsWith("call ")){
            $wk = $wk.ToLower().replace("call ","")
        }
        if($wk.ToLower().StartsWith("private ")){
            $wk = $wk.ToLower().replace("private ","")
        }
        if($wk.ToLower().StartsWith("public ")){
            $wk = $wk.ToLower().replace("public ","")
        }
        if($wk.ToLower().StartsWith("sub ")){
            $wk = $wk.ToLower().replace("sub ","")
            $flg = $true
        }
        if($wk.ToLower().StartsWith("function ")){
            $wk = $wk.ToLower().replace("function ","")
            $flg = $true
        }
        if ($flg) {
            $wk = $wk.Substring(0, $wk.IndexOf("("))
        }
    }
    return $wk
}

#$lineが関数の終了行か判定
function isEndFunc($line){
    $flg = $false
    if ([String]::IsNullOrEmpty($line) -eq $false){
        if($line.ToLower() -eq "end function"){
            $flg = $true
        }
        if($line.ToLower() -eq "end sub"){
            $flg = $true
        }
    }
    return $flg
}

#$lineが関数の開始行か判定
function isFunc($line,$funcs){
    $flg = $false
    if ([String]::IsNullOrEmpty($line) -eq $false){
        foreach ($func in $funcs){
            if($line.IndexOf($func) -ne -1){
                $flg = $true
                break
            }
        }
    }
    return $flg
}

function get-defineidx($lines,$line){
    $flg = $false
    $ret = -1
    if ([String]::IsNullOrEmpty($line) -eq $false){
        for($idx=0; $idx -lt $lines.Count; $idx++) {
        #foreach ($line in $lines){
            $wk = $lines[$idx]
            if ([String]::IsNullOrEmpty($wk) -eq $false){
                $flg = $false
                if($wk.ToLower().StartsWith("private ")){
                    $wk = $wk.ToLower().replace("private ","")
                }
                if($wk.ToLower().StartsWith("public ")){
                    $wk = $wk.ToLower().replace("public ","")
                }
                if($wk.ToLower().StartsWith("sub ")){
                    $wk = $wk.ToLower().replace("sub ","")
                    $flg = $true
                }
                if($wk.ToLower().StartsWith("function ")){
                    $wk = $wk.ToLower().replace("function ","")
                    $flg = $true
                }
                if ($flg) {
                    $wk = $wk.Substring(0, $wk.IndexOf("("))
                    if( $wk -eq $line){
                        $ret = $idx
                        break
                    }
                }
            }
        }
    }
    return $ret
}

function write-uml($lines,$func){
    #foreach ($line in $lines){

    #宣言行を探す
    $idxx = get-defineidx $lines $func

    for($idx=$idxx+1; $idx -lt $lines.Count; $idx++) {
        $line = MyTrim $lines[$idx] 
        if ([String]::IsNullOrEmpty($line) -eq $false){
            $lineidxx =  MyTrim $lines[$idxx]               
            if(isEndFunc($line)){
                if($myStack.Count -ne 0){
                    $outt = $myStack.Pop()
                    $outt | Out-File -FilePath $outFile -Append -Encoding utf8
                }
                break
            }else{
                $line = $line.Substring(0, $line.IndexOf("("))
                $outt = $func + " -> " + $line
                $outt | Out-File -FilePath $outFile -Append -Encoding utf8
                $outt = $func + " <-- " + $line
                $myStack.Push( $outt )
                write-uml $lines $line
            }
        }
    }
}

main

#echo $lines

<#
$mystack = new-object system.collections.stack
$myStack.Push( "The" )
$myStack.Push( "quick" )
$myStack.Push( "brown" )
$myStack.Push( "fox" )

#$ooo = new-object [System.Collections.Stack]
#$ooo.push("sss")
#echo $ooo
echo -------------
echo $mystack
#>