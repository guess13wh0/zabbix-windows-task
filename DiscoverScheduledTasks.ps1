$path = "\"

Function Convert-ToUnixDate ($PSdate) {
    $epoch = [timezone]::CurrentTimeZone.ToLocalTime([datetime]'1/1/1970')
    (New-TimeSpan -Start $epoch -End $PSdate).TotalSeconds
}

$ITEM = [string]$args[0]
$ID = [string]$args[1]

switch ($ITEM) {
    "DiscoverTasks" {
        $apptasks = Get-ScheduledTask -TaskPath $path | Where-Object { $_.State -eq "Ready" -or $_.State -eq "Running" }
        $apptasksok1 = $apptasks.TaskName
        if ($apptasksok1 -ne $null) {
            $apptasksok = $apptasksok1.Replace('â', '&acirc;').Replace('à', '&agrave;').Replace('ç', '&ccedil;').Replace('é', '&eacute;').Replace('è', '&egrave;').Replace('ê', '&ecirc;')
            $idx = 1
            Write-Host "{"
            Write-Host " `"data`":[`n"
            foreach ($currentapptasks in $apptasksok) {
                if ($idx -lt $apptasksok.Count) {
                    $line = "{ `"{#APPTASKS}`" : `"" + $currentapptasks + "`" },"
                    Write-Host $line
                }
                elseif ($idx -ge $apptasksok.Count) {
                    $line = "{ `"{#APPTASKS}`" : `"" + $currentapptasks + "`" }"
                    Write-Host $line
                }
                $idx++
            } 
            Write-Host
            Write-Host " ]"
            Write-Host "}"
        } else {
            Write-Host "No tasks found."
        }
    }

    "TaskLastResult" {
        [string]$name = $ID
        $name1 = $name.Replace('&acirc;', 'â').Replace('&agrave;', 'à').Replace('&ccedil;', 'ç').Replace('&eacute;', 'é').Replace('&egrave;', 'è').Replace('&ecirc;', 'ê')
        $pathtask = Get-ScheduledTask -TaskPath "*" -TaskName "$name1"
        $pathtask1 = $pathtask.Taskpath
        $taskResult = Get-ScheduledTaskInfo -TaskPath "$pathtask1" -TaskName "$name1"
        Write-Output ($taskResult.LastTaskResult)
    }

    "TaskLastRunTime" {
        [string]$name = $ID
        $name1 = $name.Replace('&acirc;', 'â').Replace('&agrave;', 'à').Replace('&ccedil;', 'ç').Replace('&eacute;', 'é').Replace('&egrave;', 'è').Replace('&ecirc;', 'ê')
        $pathtask = Get-ScheduledTask -TaskPath "*" -TaskName "$name1"
        $pathtask1 = $pathtask.Taskpath
        $taskResult = Get-ScheduledTaskInfo -TaskPath "$pathtask1" -TaskName "$name1"
        $taskResult1 = $taskResult.LastRunTime
        $date = Get-Date -Date "01/01/1970"
        $taskResult2 = Convert-ToUnixDate $taskResult1
        Write-Output ($taskResult2)
    }

    "TaskNextRunTime" {
        [string]$name = $ID
        $name1 = $name.Replace('&acirc;', 'â').Replace('&agrave;', 'à').Replace('&ccedil;', 'ç').Replace('&eacute;', 'é').Replace('&egrave;', 'è').Replace('&ecirc;', 'ê')
        $pathtask = Get-ScheduledTask -TaskPath "*" -TaskName "$name1"
        $pathtask1 = $pathtask.Taskpath
        $taskResult = Get-ScheduledTaskInfo -TaskPath "$pathtask1" -TaskName "$name1"
        $taskResult1 = $taskResult.NextRunTime
        $date = Get-Date -Date "01/01/1970"
        $taskResult2 = Convert-ToUnixDate $taskResult1
        Write-Output ($taskResult2)
    }

    "TaskState" {
        [string]$name = $ID
        $name1 = $name.Replace('&acirc;', 'â').Replace('&agrave;', 'à').Replace('&ccedil;', 'ç').Replace('&eacute;', 'é').Replace('&egrave;', 'è').Replace('&ecirc;', 'ê')
        $pathtask = Get-ScheduledTask -TaskPath "*" -TaskName "$name1"
        $pathtask1 = $pathtask.State
        Write-Output ($pathtask1)
    }
}
