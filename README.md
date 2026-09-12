# Analog Saat — Lively Duvar Kağıdı

Siyah zeminli canlı analog saat: akrep/yelkovan/saniye, Türkçe tarih,
CPU ve RAM göstergeleri, disk doluluk kartı. Tek dosya, harici kütüphanesiz.

## Kurulum

1. [Lively Wallpaper](https://www.microsoft.com/store/apps/9NTM2QC6QWS7)'ı kurun.
2. Bu klasörü Lively penceresine sürükleyip bırakın.
3. `kurulum.ps1` dosyasına sağ tıklayıp **PowerShell ile çalıştır** deyin
   (yönetici yetkisi gerekmez). Bu işlem:
   - Disk verisini üreten `AnalogSaatDisk` zamanlanmış görevini kurar
     (oturum açılışında + 2 dakikada bir),
   - Yenile düğmesi için `analogsaat://` protokolünü kaydeder,
   - Lively'nin yerel dosyayı okuyabilmesi için WebView2 bayrağını ayarlar.
4. Lively'yi kapatıp açın. Duvar kağıdı olarak ayarlayın.

## Notlar

- CPU/RAM göstergeleri **yalnızca Lively duvar kağıdında** çalışır
  (Lively'nin `--system-information` API'si üzerinden).
- Disk kartı `disk-yaz.ps1` betiğinin ürettiği `disk.json` dosyasını okur.
  Tarayıcıda açıldığında disk kartı çalışmaz, diğer her şey çalışır.
- %90 ve üzeri disk doluluğu kırmızı gösterilir.

## Kaldırma

```powershell
Unregister-ScheduledTask -TaskName "AnalogSaatDisk" -Confirm:$false
Remove-Item -Path "HKCU:\Software\Classes\analogsaat" -Recurse
[Environment]::SetEnvironmentVariable("WEBVIEW2_ADDITIONAL_BROWSER_ARGUMENTS", $null, "User")
```

## Lisans

MIT — bkz. `LICENSE`.
