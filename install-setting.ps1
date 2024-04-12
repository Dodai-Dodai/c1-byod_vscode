# windows11用のスクリプト
# 1. VSCodeのインストール
winget install --id Microsoft.VisualStudioCode
# 2. 7zipのインストール
winget install --id 7zip.7zip
#3. 7zipのパスを通す(一時的)
$Env:Path = ";C:\Program Files\7-Zip"
# 3. c1-byodのインストール
curl http://150.89.235.80/lec/c1-byod/c1-byod.exe --output C:\Users\%USERNAME%\Downloads\c1-byod.7zip
7z x C:\Users\%USERNAME%\Downloads\c1-byod.7zip -oC:\Users\%USERNAME%\Downloads\c1-byod
Set-Location C:\Users\%USERNAME%\Downloads\c1-byod\c1-byod
.\start.bat
# setting jsonの編集
# settings.jsonのパス
$settingsPath = "C:\Users\%USERNAME%\AppData\Roaming\Code\User\settings.json"

# settings.jsonファイルの読み込み
$settings = Get-Content -Path $settingsPath -Raw | ConvertFrom-Json

# 新しいプロファイル設定
$newProfile = @"
{
    "path": ["C:\\oit\\c1-byod\\msys64\\usr\\bin\\bash.exe"],
    "args": ["--login"],
    "env": {"MSYSTEM": "MINGW64", "CHERE_INVOKING": "1"}
}
"@

# プロファイルの追加
if ($settings.'terminal.integrated.profiles.windows' -eq $null) {
    $settings | Add-Member -Type NoteProperty -Name 'terminal.integrated.profiles.windows' -Value @{}
}

if ($settings.'terminal.integrated.profiles.windows'.'c1-byod' -eq $null) {
    $settings.'terminal.integrated.profiles.windows' | Add-Member -Type NoteProperty -Name 'c1-byod' -Value ($newProfile | ConvertFrom-Json)
}

# 変更をsettings.jsonに書き戻す
$settings | ConvertTo-Json -Depth 99 | Set-Content -Path $settingsPath
