# Analog Saat duvar kagidi icin disk kullanim verisi uretir (tasinabilir surum).
# - Betigin bulundugu klasore ve
# - Lively kutuphanesindeki "Analog Saat" duvar kagidi klasorune
# disk.json yazar. Yonetici yetkisi gerekmez.
$ErrorActionPreference = "SilentlyContinue"

$kendiKlasoru = Split-Path -Parent $MyInvocation.MyCommand.Path
$hedefKlasorler = @($kendiKlasoru)

$kokAdaylari = @(
  (Join-Path $env:LOCALAPPDATA "Lively Wallpaper\Library\wallpapers"),
  (Join-Path $env:LOCALAPPDATA "Packages\12030rocksdanister.LivelyWallpaper_*\LocalCache\Local\Lively Wallpaper\Library\wallpapers")
)
foreach ($kok in $kokAdaylari) {
  foreach ($c in (Resolve-Path $kok -ErrorAction SilentlyContinue)) {
    foreach ($d in (Get-ChildItem -LiteralPath $c.Path -Directory -ErrorAction SilentlyContinue)) {
      $info = Join-Path $d.FullName "LivelyInfo.json"
      if (Test-Path -LiteralPath $info) {
        $baslik = Get-Content -LiteralPath $info -Raw -ErrorAction SilentlyContinue
        if ($baslik -match '"Title"\s*:\s*"Analog Saat"') {
          $hedefKlasorler += $d.FullName
        }
      }
    }
  }
}

$diskler = Get-PSDrive -PSProvider FileSystem |
  Where-Object { $_.Used -ne $null } |
  ForEach-Object {
    $toplam = $_.Used + $_.Free
    [pscustomobject]@{
      ad           = $_.Name
      etiket       = [string]$_.Description
      toplamGB     = if ($toplam -gt 0) { [math]::Round($toplam / 1GB, 1) } else { 0 }
      bosGB        = [math]::Round($_.Free / 1GB, 1)
      kullanilanGB = [math]::Round($_.Used / 1GB, 1)
      yuzde        = if ($toplam -gt 0) { [math]::Round($_.Used / $toplam * 100, 1) } else { 0 }
    }
  }

$json = @{ guncelleme = (Get-Date).ToString("o"); diskler = @($diskler) } | ConvertTo-Json -Depth 3

foreach ($klasor in ($hedefKlasorler | Select-Object -Unique)) {
  $json | Set-Content -LiteralPath (Join-Path $klasor "disk.json") -Encoding UTF8 -NoNewline
}
