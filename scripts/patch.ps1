param (
    [Parameter(Mandatory=$true)][string]$root_dir
)

$rs_dir = [IO.Path]::Combine($root_dir, "rs")
$umod_dir = [IO.Path]::Combine($root_dir, "umod")
$resources_dir = [IO.Path]::Combine($rs_dir, "resources")
$tools_dir = [IO.Path]::Combine($umod_dir, "tools")
$patcher_exe = [IO.Path]::Combine($tools_dir, "OxidePatcher.exe")
$patcher_file = [IO.Path]::Combine($resources_dir, "Rust.opj")
$project_dir = [IO.Path]::Combine($umod_dir, "src")
$deps_dir = [IO.Path]::Combine($project_dir, "Dependencies")
$linux_platform_dir = [IO.Path]::Combine($deps_dir, "linux")
$win_platform_dir = [IO.Path]::Combine($deps_dir, "windows")
$linux_managed_dir = [IO.Path]::Combine($linux_platform_dir, "RustDedicated_Data", "Managed")
$win_managed_dir = [IO.Path]::Combine($win_platform_dir, "RustDedicated_Data", "Managed")

$modifiedFiles = Get-ChildItem -Path $linux_managed_dir -Filter "*_Original.*"
foreach ($file in $modifiedFiles) {
    $file_path = Join-Path $linux_managed_dir $file
    Remove-Item -Force -Path $file_path
    Write-Host "Removed Original: $file"
}

$modifiedFiles = Get-ChildItem -Path $win_managed_dir -Filter "*_Original.*"
foreach ($file in $modifiedFiles) {
    $file_path = Join-Path $win_managed_dir $file
    Remove-Item -Force -Path $file_path
    Write-Host "Removed Original: $file"
}

Start-Process $patcher_exe -WorkingDirectory $linux_managed_dir -ArgumentList "-c -p `"$linux_managed_dir`" $patcher_file" -NoNewWindow -Wait
Start-Process $patcher_exe -WorkingDirectory $win_managed_dir -ArgumentList "-c -p `"$win_managed_dir`" $patcher_file" -NoNewWindow -Wait