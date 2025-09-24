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
$worldTemplate = @(
    (Join-Path $repoRoot '.specify/templates/story/world-template.md'),
    (Join-Path $repoRoot 'templates/story/world-template.md')
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not (Test-Path $worldFile)) {
    if ($worldTemplate) {
        (Get-Content $worldTemplate) -replace '\[TITLE\]', 'TODO Title' | Set-Content -Path $worldFile -NoNewline
        Add-Content -Path $worldFile -Value ""
    } else {
        @(
            '# 世界设定概览',
            '',
            '**故事标题**： TODO Title',
            '**题材风格**： ',
            '**主要时代 / 地点**： ',
            '**超自然或科技设定**： ',
            '',
            '## 核心支柱',
            '- **主题焦点**： ',
            '- **情绪氛围**： ',
            '- **冲突核心**： ',
            '',
            '## 地理与社会结构',
            '| 项目 | 说明 |',
            '| ---- | ---- |',
            '| 中心城市 / 关键地点 | ',
            '| 地理区域与地标 | ',
            '| 社会阶层与权力分配 | ',
            '| 技术或文化发展水平 | ',
            '| 经济与贸易特点 | ',
            '',
            '## 能力体系与限制',
            '- **能力 / 技艺**： ',
            '- **限制与代价**： ',
            '- **规训与禁忌**： ',
            '',
            '## 历史脉络',
            '1. **近期事件** —— ',
            '2. **隐秘真相** —— ',
            '3. **紧张热点** —— ',
            '',
            '## 文化风貌',
            '- **礼俗与仪式**： ',
            '- **语言与表达**： ',
            '- **日常生活与饮食**： ',
            '- **信仰体系**： ',
            '',
            '## 故事钩子',
            '- **开端契机**： ',
            '- **前期筹码**： ',
            '- **后续升级路径**： ',
            '',
            '## 待补充问题',
            '- ',
            '',
            '## 决策索引',
            '- (引用 LOG#) '
        ) | Set-Content -Path $worldFile
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

$charTemplate = @(
    (Join-Path $repoRoot '.specify/templates/story/character-template.md'),
    (Join-Path $repoRoot 'templates/story/character-template.md')
) | Where-Object { Test-Path $_ } | Select-Object -First 1

$logFile = Join-Path $conversationDir ("lore-" + (Get-Date -Format 'yyyyMMdd') + '.md')
if (-not (Test-Path $logFile)) {
    @(
        "# /lore 对话记录 $(Get-Date -Format 'yyyy-MM-dd')",
        '',
        '> 记录与 /lore 相关的往返内容。每条发言请使用 `#### [LOG#YYYYMMDD-XX] 角色` 标题继续编号，正文保持原话，可在行尾添加标签。',
        '',
        "#### [LOG#$(Get-Date -Format 'yyyyMMdd')-01] 系统",
        '',
        '欢迎使用 `/lore`，请沿用以上格式写入新的对话记录。',
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
        '- 收录尚未获得作者确认的设定、问题与行动项，并标注来源 `LOG#`。',
        '- 在写入世界观或角色档案前，请再次与作者确认并勾选完成。',
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
