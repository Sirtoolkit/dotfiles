function copyit
    $argv 2>&1 | tee /dev/tty | pbcopy
end