#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [switch]$Json
)
$ErrorActionPreference = 'Stop'

function Find-RepositoryRoot {
    param(
        [string]$StartDir,
        [string[]]$Markers = @('.git', '.specify', 'logs')
    )
    $current = Resolve-Path $StartDir
    while ($true) {
        foreach ($marker in $Markers) {
            if (Test-Path (Join-Path $current $marker)) {
                return $current
            }
        }
        $parent = Split-Path $current -Parent
        if ($parent -eq $current) { return $null }
        $current = $parent
    }
}

$fallbackRoot = Find-RepositoryRoot -StartDir $PSScriptRoot
if (-not $fallbackRoot) {
    Write-Error "Error: could not determine repository root"
    exit 1
}

try {
    $repoRoot = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -ne 0) { throw "git unavailable" }
} catch {
    $repoRoot = $fallbackRoot
}

$logDir = Join-Path $repoRoot 'logs/adaptations'
New-Item -ItemType Directory -Path $logDir -Force | Out-Null

$indexFile = Join-Path $logDir 'index.md'
if (-not (Test-Path $indexFile)) {
    @('# Adaptation Log Index', '', '- [adaptations_001-050.md](adaptations_001-050.md)') | Set-Content -Path $indexFile
}

function Get-CurrentLog {
    param([string]$LogDir)
    $latest = $null
    $latestEnd = 0
    Get-ChildItem -Path $LogDir -Filter 'adaptations_*-*.md' -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.Name -match 'adaptations_(\d{3})-(\d{3})\.md') {
            $end = [int]$matches[2]
            if ($end -gt $latestEnd) {
                $latestEnd = $end
                $latest = $_.FullName
            }
        }
    }
    return $latest
}

function New-LogFile {
    param(
        [int]$Start,
        [int]$End
    )
    $startLabel = '{0:000}' -f $Start
    $endLabel = '{0:000}' -f $End
    $target = Join-Path $logDir "adaptations_${startLabel}-${endLabel}.md"
    if (-not (Test-Path $target)) {
        $template = Join-Path $repoRoot '.specify/templates/story/adaptation-log-template.md'
        if (Test-Path $template) {
            (Get-Content $template) -replace '\[RANGE\]', "$startLabel-$endLabel" | Set-Content -Path $target -NoNewline
            Add-Content -Path $target -Value ""
        } else {
            @("# Adaptation Log $startLabel-$endLabel", '', '| Entry | Date | Trigger | Affected Artifacts | Summary |', '| ----- | ---- | ------- | ------------------ | ------- |') | Set-Content -Path $target
        }
        if (-not (Select-String -Path $indexFile -Pattern "adaptations_${startLabel}-${endLabel}\.md" -SimpleMatch -Quiet)) {
            Add-Content -Path $indexFile -Value "- [adaptations_${startLabel}-${endLabel}.md](adaptations_${startLabel}-${endLabel}.md)"
        }
    }
    return $target
}

$currentLog = Get-CurrentLog -LogDir $logDir
if (-not $currentLog) {
    $currentLog = New-LogFile -Start 1 -End 50
}

$rollover = $false
if (Test-Path $currentLog) {
    $entryCount = (Select-String -Path $currentLog -Pattern '^\| [0-9]+' -AllMatches | Measure-Object).Count
    $sizeBytes = (Get-Item $currentLog).Length
    if ($entryCount -ge 50 -or $sizeBytes -ge 80000) {
        $rollover = $true
    }
}

if ($rollover) {
    if ($currentLog -match 'adaptations_(\d{3})-(\d{3})\.md') {
        $end = [int]$matches[2]
        $start = $end + 1
        $newLog = New-LogFile -Start $start -End ($start + 49)
        $currentLog = $newLog
    }
}

$projectOverview = Join-Path $repoRoot 'project_overview.md'

if ($Json) {
    [pscustomobject]@{
        REPO_ROOT = $repoRoot
        ADAPTATION_LOG = $currentLog
        INDEX_FILE = $indexFile
        PROJECT_OVERVIEW = $projectOverview
    } | ConvertTo-Json -Compress
} else {
    Write-Output "REPO_ROOT: $repoRoot"
    Write-Output "ADAPTATION_LOG: $currentLog"
    Write-Output "INDEX_FILE: $indexFile"
    Write-Output "PROJECT_OVERVIEW: $projectOverview"
}
