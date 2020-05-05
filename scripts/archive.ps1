param (
    [Parameter(Mandatory=$true)][string]$root_dir
)

Add-Type -AssemblyName System.IO.Compression.FileSystem

$output_dir = [IO.Path]::Combine($root_dir, "output")
$umod_dir = [IO.Path]::Combine($root_dir, "umod")
$project_dir = [IO.Path]::Combine($umod_dir, "src")
$deps_dir = [IO.Path]::Combine($project_dir, "Dependencies")
$bundle_dir = [IO.Path]::Combine($project_dir, "bin", "Bundle")

$linux_output_archive = [IO.Path]::Combine($output_dir, "Oxide.Rust-linux.zip")
$win_output_archive = [IO.Path]::Combine($output_dir, "Oxide.Rust.zip")

$linux_output_dir = [IO.Path]::Combine($output_dir, "Oxide.Rust-linux")
$win_output_dir = [IO.Path]::Combine($output_dir, "Oxide.Rust")

$linux_bundle_dir = [IO.Path]::Combine($bundle_dir, "Oxide.Rust-linux")
$win_bundle_dir = [IO.Path]::Combine($bundle_dir, "Oxide.Rust")

$linux_platform_dir = [IO.Path]::Combine($deps_dir, "linux")
$win_platform_dir = [IO.Path]::Combine($deps_dir, "windows")

$linux_managed_dir = [IO.Path]::Combine($linux_platform_dir, "RustDedicated_Data", "Managed")
$win_managed_dir = [IO.Path]::Combine($win_platform_dir, "RustDedicated_Data", "Managed")

class FixedEncoder : System.Text.UTF8Encoding {
    FixedEncoder() : base($true) { }

    [byte[]] GetBytes([string] $s) {
        $s = $s.Replace("\", "/");
        return ([System.Text.UTF8Encoding]$this).GetBytes($s);
    }
}

if ([IO.Directory]::Exists($output_dir)) {
    [IO.Directory]::Delete($output_dir, $true)
}
[IO.Directory]::CreateDirectory($output_dir) | Out-Null

Copy-Item -Recurse -Path $linux_bundle_dir -Destination $linux_output_dir
$modifiedFiles = Get-ChildItem -Path $linux_managed_dir -Filter "*_Original.*"
foreach ($file in $modifiedFiles) {
    $file = $file -creplace "_Original"
    $file_path = Join-Path $linux_managed_dir $file
    $output_path = [IO.Path]::Combine($linux_output_dir, "RustDedicated_Data", "Managed")
    Copy-Item -Path $file_path -Destination $output_path -Force
    Write-Host "Copied Modified $file"
}
[IO.Compression.ZipFile]::CreateFromDirectory($linux_output_dir, $linux_output_archive, [IO.Compression.CompressionLevel]::Optimal, $false, [FixedEncoder]::new())

Copy-Item -Recurse -Path $win_bundle_dir -Destination $win_output_dir
$modifiedFiles = Get-ChildItem -Path $win_managed_dir -Filter "*_Original.*"
foreach ($file in $modifiedFiles) {
    $file = $file -creplace "_Original"
    $file_path = Join-Path $win_managed_dir $file
    $output_path = [IO.Path]::Combine($win_output_dir, "RustDedicated_Data", "Managed")
    Copy-Item -Path $file_path -Destination $output_path -Force
    Write-Host "Copied Modified $file"
}
[IO.Compression.ZipFile]::CreateFromDirectory($win_output_dir, $win_output_archive, [IO.Compression.CompressionLevel]::Optimal, $false, [FixedEncoder]::new())