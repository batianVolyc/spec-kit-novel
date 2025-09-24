#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [switch]$Json
)
$ErrorActionPreference = 'Stop'

function Find-RepositoryRoot {
    param(
        [string]$StartDir,
        [string[]]$Markers = @('.git', '.specify', 'lore')
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

$loreDir = Join-Path $repoRoot 'lore'
$charactersDir = Join-Path $repoRoot 'characters'
$conversationDir = Join-Path $loreDir 'conversation'
$pendingDir = Join-Path $loreDir 'pending'
New-Item -ItemType Directory -Path $loreDir -Force | Out-Null
New-Item -ItemType Directory -Path $charactersDir -Force | Out-Null
New-Item -ItemType Directory -Path $conversationDir -Force | Out-Null
New-Item -ItemType Directory -Path $pendingDir -Force | Out-Null

$worldFile = Join-Path $loreDir 'world.md'
$worldTemplate = Join-Path $repoRoot '.specify/templates/story/world-template.md'
if (-not (Test-Path $worldFile)) {
    if (Test-Path $worldTemplate) {
        (Get-Content $worldTemplate) -replace '\[TITLE\]', 'TODO Title' | Set-Content -Path $worldFile -NoNewline
        Add-Content -Path $worldFile -Value ""
    } else {
        '# World Overview' | Set-Content -Path $worldFile
        '(fill in after /lore)' | Add-Content -Path $worldFile
    }
}

$rosterFile = Join-Path $charactersDir 'roster.md'
if (-not (Test-Path $rosterFile)) {
    @(
        '# Character Roster',
        '',
        '| Name | Role | Status |',
        '| ---- | ---- | ------ |'
    ) | Set-Content -Path $rosterFile
}

$charTemplate = Join-Path $repoRoot '.specify/templates/story/character-template.md'

$logFile = Join-Path $conversationDir ("lore-" + (Get-Date -Format 'yyyyMMdd') + '.md')
if (-not (Test-Path $logFile)) {
    @(
        "# /lore 对话记录 $(Get-Date -Format 'yyyy-MM-dd')",
        '',
        '> 记录与 /lore 相关的问答与讨论，未确认内容请同步到待确认清单。',
        '',
        '---',
        ''
    ) | Set-Content -Path $logFile
}

$pendingFile = Join-Path $pendingDir 'todo.md'
if (-not (Test-Path $pendingFile)) {
    @(
        '# /lore 待确认事项',
        '',
        '- 将尚未获得作者确认的设定、问题与行动项放在此处。',
        '- 作者确认后，再移入 `world.md` 等正式档案。',
        '',
        '---',
        ''
    ) | Set-Content -Path $pendingFile
}

if ($Json) {
    [pscustomobject]@{
        REPO_ROOT = $repoRoot
        WORLD_FILE = $worldFile
        CHARACTERS_DIR = $charactersDir
        CHARACTER_TEMPLATE = $charTemplate
        ROSTER_FILE = $rosterFile
        LOG_FILE = $logFile
        PENDING_FILE = $pendingFile
    } | ConvertTo-Json -Compress
} else {
    Write-Output "REPO_ROOT: $repoRoot"
    Write-Output "WORLD_FILE: $worldFile"
    Write-Output "CHARACTERS_DIR: $charactersDir"
    Write-Output "CHARACTER_TEMPLATE: $charTemplate"
    Write-Output "ROSTER_FILE: $rosterFile"
    Write-Output "LOG_FILE: $logFile"
    Write-Output "PENDING_FILE: $pendingFile"
}
