# ===== Powershell script to delete sub folders and files if the creation date is >7 days but maintain parent folders of sub folders and files <7 days old =====


# ===== Delete previous Error Log file if it exists =====
if (Test-Path "C:\Scripts\Purge_F_Drive\ErrorLog.txt") {del "C:\Scripts\Purge_F_Drive\ErrorLog.txt"}

# ===== Reset Error count and contents =====
$error.Clear()


# ===== Set folder path =====
$dump_path = "F:\shares\shared"

# ===== Set minimum age of files and folders =====
$max_days = "-14"

# ===== Get the current date =====
$curr_date = Get-Date

# ===== Determine how far back we go based on current date =====
$del_date = $curr_date.AddDays($max_days)


# === Delete the files ==

$deleted = @()

Get-ChildItem $dump_path -Recurse | Where-Object {
  -not $_.PSIsContainer -and $_.CreationTime -lt $del_date
} | ForEach-Object {
  $deleted += $_.FullName
  $_
} | Remove-Item -Force


# ===== Delete the empty folders =====

function Remove-EmptyFolders($folder) {
  Get-ChildItem $folder | Where-Object { $_.PSIsContainer } | ForEach-Object {
    $path = $_.FullName
    Remove-Emptyfolders $path
    if ( @(Get-ChildItem $path -Recurse | Where-Object { -not $_.PSIsContainer}).Length -eq 0 ) {
      $deleted += $path
      Remove-Item $path -Recurse -Force
    }
  }
}

Remove-EmptyFolders $dump_path


# ===== Write a list of the deleted files to a Log File =====

"Total # of Files Deleted: " | Out-File "C:\Scripts\Purge_F_Drive\RecentlyDeleted.txt"
$deleted.Count | Out-File "C:\Scripts\Purge_F_Drive\RecentlyDeleted.txt" -Append

$deleted | Out-File "C:\Scripts\Purge_F_Drive\RecentlyDeleted.txt" -Append


# ===== Check for any errors and log them if they occurred =====

if ($error.count -ne 0) {$error | Out-File "C:\Scripts\Purge_F_Drive\ErrorLog.txt"}