#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [switch]$Json
)
$ErrorActionPreference = 'Stop'

function Find-RepositoryRoot {
    param(
        [string]$StartDir,
        [string[]]$Markers = @('.git', '.specify', 'plots')
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

$plotsDir = Join-Path $repoRoot 'plots'
$conversationDir = Join-Path $plotsDir 'conversation'
$pendingDir = Join-Path $plotsDir 'pending'
New-Item -ItemType Directory -Path $plotsDir -Force | Out-Null
New-Item -ItemType Directory -Path $conversationDir -Force | Out-Null
New-Item -ItemType Directory -Path $pendingDir -Force | Out-Null

$outlineFile = Join-Path $plotsDir 'outline.md'
$outlineTemplate = @(
    (Join-Path $repoRoot '.specify/templates/story/outline-template.md'),
    (Join-Path $repoRoot 'templates/story/outline-template.md')
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not (Test-Path $outlineFile)) {
    if ($outlineTemplate) {
        (Get-Content $outlineTemplate) -replace '\[TITLE\]', 'TODO Title' | Set-Content -Path $outlineFile -NoNewline
        Add-Content -Path $outlineFile -Value ""
    } else {
        '# Story Outline' | Set-Content -Path $outlineFile
    }
}

$arcsFile = Join-Path $plotsDir 'arcs.md'
$arcsTemplate = @(
    (Join-Path $repoRoot '.specify/templates/story/arc-template.md'),
    (Join-Path $repoRoot 'templates/story/arc-template.md')
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not (Test-Path $arcsFile)) {
    if ($arcsTemplate) {
        Get-Content $arcsTemplate | Set-Content -Path $arcsFile
    } else {
        '# Plot Arcs' | Set-Content -Path $arcsFile
    }
}

$overviewFile = Join-Path $repoRoot 'project_overview.md'
$overviewTemplate = @(
    (Join-Path $repoRoot '.specify/templates/story/project-overview-template.md'),
    (Join-Path $repoRoot 'templates/story/project-overview-template.md')
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not (Test-Path $overviewFile)) {
    if ($overviewTemplate) {
        (Get-Content $overviewTemplate) -replace '\[TITLE\]', 'TODO Title' | Set-Content -Path $overviewFile -NoNewline
        Add-Content -Path $overviewFile -Value ""
    } else {
        @('# Project Overview', '', '(Generated after /weave completes.)') | Set-Content -Path $overviewFile
    }
}

$logFile = Join-Path $conversationDir ("weave-" + (Get-Date -Format 'yyyyMMdd') + '.md')
if (-not (Test-Path $logFile)) {
    @(
        "# /weave 对话记录 $(Get-Date -Format 'yyyy-MM-dd')",
        '',
        '> 记录与 /weave 相关的讨论。每条发言请使用 `#### [LOG#YYYYMMDD-XX] 角色` 标题继续编号，正文保持原话，可在行尾添加标签。待确认决策请同步到 pending 清单。',
        '',
        "#### [LOG#$(Get-Date -Format 'yyyyMMdd')-01] 系统",
        '',
        '欢迎使用 `/weave`，请沿用以上格式写入新的对话记录。',
        '',
        '---',
        ''
    ) | Set-Content -Path $logFile
}

$pendingFile = Join-Path $pendingDir 'todo.md'
if (-not (Test-Path $pendingFile)) {
    @(
        '# /weave 待确认事项',
        '',
        '- 汇总尚未确认的结构调整、篇章安排与节奏建议，并标注来源 `LOG#`。',
        '- 作者确认后，再写入 `outline.md`、`arcs.md` 等正式文档。',
        '',
        '---',
        ''
    ) | Set-Content -Path $pendingFile
}

if ($Json) {
    [pscustomobject]@{
        REPO_ROOT = $repoRoot
        PLOTS_DIR = $plotsDir
        OUTLINE_FILE = $outlineFile
        ARCS_FILE = $arcsFile
        PROJECT_OVERVIEW = $overviewFile
        LOG_FILE = $logFile
        PENDING_FILE = $pendingFile
    } | ConvertTo-Json -Compress
} else {
    Write-Output "REPO_ROOT: $repoRoot"
    Write-Output "PLOTS_DIR: $plotsDir"
    Write-Output "OUTLINE_FILE: $outlineFile"
    Write-Output "ARCS_FILE: $arcsFile"
    Write-Output "PROJECT_OVERVIEW: $overviewFile"
    Write-Output "LOG_FILE: $logFile"
    Write-Output "PENDING_FILE: $pendingFile"
}
