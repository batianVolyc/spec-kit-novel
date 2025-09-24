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
$conversationDir = Join-Path $ideasDir 'conversation'
$pendingDir = Join-Path $ideasDir 'pending'
New-Item -ItemType Directory -Path $ideasDir -Force | Out-Null
New-Item -ItemType Directory -Path $conversationDir -Force | Out-Null
New-Item -ItemType Directory -Path $pendingDir -Force | Out-Null

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

    $templateCandidates = @(
        (Join-Path $repoRoot '.specify/templates/story/idea-session-template.md'),
        (Join-Path $repoRoot 'templates/story/idea-session-template.md')
    )
    $template = $templateCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

    if ($template) {
        (Get-Content $template) -replace '\[DATE\]', (Get-Date -Format 'yyyy-MM-dd') | Set-Content -Path $sessionFile -NoNewline
        Add-Content -Path $sessionFile -Value ""
    } else {
        @(
            "# 创意基石 $(Get-Date -Format 'yyyy-MM-dd')",
            '',
            '### 创意概览',
            '- ',
            '',
            '### 人物设定',
            '- ',
            '',
            '### 世界与规则',
            '- ',
            '',
            '### 故事情节（已确认）',
            '- ',
            '',
            '### 风险与待决',
            '- ',
            '',
            '## 决策索引',
            "- (引用 LOG#$(Get-Date -Format 'yyyyMMdd')-01) 初始化"
        ) | Set-Content -Path $sessionFile
    }
}

$sessionName = [System.IO.Path]::GetFileNameWithoutExtension($sessionFile)
$sessionLog = Join-Path $conversationDir "${sessionName}-conversation.md"
$sessionPending = Join-Path $pendingDir "${sessionName}-pending.md"

$env:NOVEL_IDEA_SESSION = $sessionFile
$env:NOVEL_IDEA_SESSION_LOG = $sessionLog
$env:NOVEL_IDEA_SESSION_PENDING = $sessionPending

if (-not (Test-Path $sessionLog)) {
    $label = Get-Date -Format 'yyyy-MM-dd'
    @(
        "# /spark 对话记录 $label",
        '',
        '> 仅记录用户与 /spark 之间的往返对话。请使用 `#### [LOG#YYYYMMDD-XX] 角色` 标题记录每条发言，XX 递增；正文保持原话，便于引用。',
        '',
        "#### [LOG#$(Get-Date -Format 'yyyyMMdd')-01] 系统",
        '',
        '欢迎使用 `/spark`，请按照上述格式继续记录。',
        '',
        '---',
        ''
    ) | Set-Content -Path $sessionLog
}

if (-not (Test-Path $sessionPending)) {
    @(
        '# /spark 待确认事项',
        '',
        '- 记录所有尚未得到作者确认的提案、问题与待办，并标注来源 `LOG#`。',
        '- 勾选或移动至创意基石前，请再次向作者确认。',
        '',
        '---',
        ''
    ) | Set-Content -Path $sessionPending
}

if ($Json) {
    [pscustomobject]@{
        REPO_ROOT = $repoRoot
        IDEA_DIR = $ideasDir
        SESSION_FILE = $sessionFile
        SESSION_LOG = $sessionLog
        SESSION_PENDING = $sessionPending
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
    Write-Output "SESSION_LOG: $sessionLog"
    Write-Output "SESSION_PENDING: $sessionPending"
}
