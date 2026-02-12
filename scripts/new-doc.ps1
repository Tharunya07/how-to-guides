param(
  [Parameter(Mandatory=$true)]
  [ValidateSet("foundations","setup","concepts","systems")]
  [string]$Pillar,

  [Parameter(Mandatory=$true)]
  [string]$Domain,

  [Parameter(Mandatory=$true)]
  [string]$Title
)

function Slugify([string]$s) {
  $s = $s.ToLower()
  $s = $s -replace "[^a-z0-9\s-]", ""
  $s = $s -replace "\s+", "-"
  $s = $s -replace "-+", "-"
  $s.Trim("-")
}

$slug = Slugify $Title
$today = Get-Date -Format "yyyy-MM-dd"

$dir = Join-Path "content" (Join-Path $Pillar $Domain)
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$path = Join-Path $dir "$slug.md"

$template = Join-Path "templates" "$Pillar.md"
if (!(Test-Path $template)) {
  Write-Host "Template not found: $template"
  exit 1
}

$content = Get-Content $template -Raw
$content = $content -replace "<Title>", $Title
$content = $content -replace "<domain>", $Domain
$content = $content -replace 'created: "YYYY-MM-DD"', "created: `"$today`""
$content = $content -replace 'updated: "YYYY-MM-DD"', "updated: `"$today`""

Set-Content -Path $path -Value $content -Encoding UTF8
Write-Host "Created: $path"
