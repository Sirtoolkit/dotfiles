alias dbb="flutter clean && dart run build_runner build -d"
alias dbw="flutter clean && dart run build_runner watch -d"
alias mbf="mason make feature_brick --project_name $(cat pubspec.yaml | awk 'NR==1 {print; exit}' | awk '{print $2}') --name"
