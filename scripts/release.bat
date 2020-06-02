git remote set-url origin https://%1:%2@github.com/Raid-Simulator/%4.git
git tag %3
git push
git push --tags

"C:\Program Files (x86)\github-release\bin\windows\amd64\github-release.exe" release --security-token %2 --user Raid-Simulator --repo %4 --tag %3 --name Build-%3
"C:\Program Files (x86)\github-release\bin\windows\amd64\github-release.exe" upload --security-token %2 --user Raid-Simulator --repo %4 --tag %3 --name Oxide.Rust.zip --file "..\output\Oxide.Rust.zip"
"C:\Program Files (x86)\github-release\bin\windows\amd64\github-release.exe" upload --security-token %2 --user Raid-Simulator --repo %4 --tag %3 --name Oxide.Rust-linux.zip --file "..\output\Oxide.Rust-linux.zip"