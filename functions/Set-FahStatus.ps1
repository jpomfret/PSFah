<#
.SYNOPSIS
Sets the status of an already running FaH Client

.DESCRIPTION
Sets the status of an already running FaH Client

Fold - Unpause all folding slots on this client
Pause - Pause all folding slots on this client
Finish - Finish all this client's currently active work units then pause

.PARAMETER Status
Sets the status of 'Fold', 'Pause' or 'Finish'

.EXAMPLE
Set-FahStatus -Status Fold

Instructs the client to unpause all slots on this client.

.EXAMPLE
Set-FahStatus -Status Finish

Instructs the client to finish work units and then pause

.NOTES
Author - Jess Pomfret - 2020/05/09

#>
function Set-FahStatus  {
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [ValidateSet('Fold','Pause','Finish')]
        [String]$Status
    )

    try {
        $client = Get-Process FAHClient -ErrorAction Stop
        $clientPath = $client.Path
    }
    catch {
        Throw 'The FAHClient Needs to be running'
        Exit
    }

    $command = switch ($Status) {
        'Fold' {'--send-unpause'}
        'Pause' {'--send-pause'}
        'Finish' {'--send-finish'}
    }

    try {
        Write-Output ('Setting status to {0}' -f $Status)
        & $clientPath $command
    }
    catch {
        Throw ('Setting FAH Status to {0} was unsuccessful' -f $Status)
    }
}