#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$Fresh
)
$ErrorActionPreference = 'Stop'

function Find-RepositoryRoot {
    param(
        [string]$StartDir,
        [string[]]$Markers = @('.git', '.specify', 'ideas')
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
    if ($LASTEXITCODE -ne 0) { throw "Git not available" }
} catch {
    $repoRoot = $fallbackRoot
}

$ideasDir = Join-Path $repoRoot 'ideas'
New-Item -ItemType Directory -Path $ideasDir -Force | Out-Null

$sessionFile = $null
$reused = $false
if (-not $Fresh) {
    $existing = Get-ChildItem -Path $ideasDir -Filter 'session-*.md' -File |
        Sort-Object Name |
        Select-Object -Last 1
    if ($existing) {
        $sessionFile = $existing.FullName
        $reused = $true
    }
}

if (-not $sessionFile) {
    $dateStamp = Get-Date -Format 'yyyyMMdd'
    for ($i = 1; $i -le 99; $i++) {
        $suffix = '{0:00}' -f $i
        $candidate = "session-$dateStamp`_$suffix.md"
        $fullPath = Join-Path $ideasDir $candidate
        if (-not (Test-Path $fullPath)) {
            $sessionFile = $fullPath
            break
        }
    }
    if (-not $sessionFile) {
        Write-Error "Too many idea sessions created for the day"
        exit 1
    }

    $template = Join-Path $repoRoot '.specify/templates/story/idea-session-template.md'
    if (Test-Path $template) {
        (Get-Content $template) -replace '\[DATE\]', (Get-Date -Format 'yyyy-MM-dd') | Set-Content -Path $sessionFile -NoNewline
        Add-Content -Path $sessionFile -Value ""
    } else {
        @(
            "# Idea Session $(Get-Date -Format 'yyyy-MM-dd')",
            '',
            '## Initial Spark',
            '> ',
            '',
            '## Clarifying Questions',
            '',
            '## Notes from Discussion',
            '',
            '## Candidate Enhancements',
            '',
            '## Decisions and Next Steps'
        ) | Set-Content -Path $sessionFile
    }
}

$env:NOVEL_IDEA_SESSION = $sessionFile

if ($Json) {
    [pscustomobject]@{
        REPO_ROOT = $repoRoot
        IDEA_DIR = $ideasDir
        SESSION_FILE = $sessionFile
        REUSED = $reused
    } | ConvertTo-Json -Compress
} else {
    Write-Output "REPO_ROOT: $repoRoot"
    Write-Output "IDEA_DIR: $ideasDir"
    if ($reused) {
        Write-Output "SESSION_FILE: $sessionFile (reused existing session)"
    } else {
        Write-Output "SESSION_FILE: $sessionFile"
    }
}
