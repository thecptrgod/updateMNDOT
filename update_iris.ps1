#Get the Iris jnlp file
wget http://data.dot.state.mn.us/metro/iris-client/iris-client.jnlp -OutFile iris.jnlp

#Parse the XML file
[xml]$cn = Get-Content iris.jnlp

#Base = code base
$base = $cn.jnlp.codebase

#resources = files
$res = $cn.jnlp.resources.jar.href

#get client URL
$cli = ($res -split "`n")[0]
$irisclient = $base + "/" + $cli

#get common URL
$cmn = ($res -split "`n")[1]
$iriscommon = $base + "/" + $cmn

#figure out file name
$clientfile = $irisclient.Substring($irisclient.LastIndexOf('/')+1)
$commonfile = $iriscommon.Substring($irisclient.LastIndexOf('/')+1)

#Download the new client and common
wget $irisclient -OutFile $clientfile
wget $iriscommon -OutFile $commonfile

#cleanup
rm iris.jnlp

#update the batch file
$updatebat = Get-Content "Run MNDOT.bat"
$oldfile = ($updatebat -split "`n")[0]
$newfile = "s:\iris\" + $clientfile
$newContent = $updatebat -replace [Regex]::Escape($oldfile), $newfile
$newContent | Set-Content -Path "Run MNDOT.bat"