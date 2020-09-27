# 2.2 Exploring Parallel processing

# Run in PS 7 on SRV1


# 1. Simulate a long running script block
$SB1 = {
  1..3 | ForEach-Object {
    "In iteration $_"
    Start-Sleep -Seconds 5
  } 
}
Invoke-Command -ScriptBlock $SB1

# 2. Time the expression
Measure-Command -Expression $SB1

# 3. Refactor into using jobs
$SB2 = {
1..3 | ForEach-Object {
  Start-Job -ScriptBlock {param($X) "Iteration $X " ;
                          Start-Sleep -Seconds 5} -ArgumentList $_ 
}
Get-Job | Wait-Job | Receive-Job -Keep
}

# 4. Invoke the script block
Invoke-Command -ScriptBlock $SB2

# 5. Remove the old jobs and time the script block
Get-Job | Remove-Job
Measure-Command -Expression $SB2

# 6. Define a script block using ForEach-Object -Parallel
$SB3 = {
1..3 | ForEach-Object -Parallel {
               "In iteration $_"
               Start-Sleep -Seconds 5
         } 
}

# 7. Execute the script block
Invoke-Command -ScriptBlock $SB3

# 8. Now measure it
Measure-Command -Expression $SB3

# 9. Create then run two short script blocks
$SB4 = {
    1..3 | ForEach-Object {
                   "In iteration $_"
             } 
}
Invoke-Command -ScriptBlock $SB4    

$SB5 = {
        1..3 | ForEach-Object -Parallel {
                       "In iteration $_"
             } 
}
Invoke-Command -ScriptBlock $SB5    

# 10. Measure time for both
Measure-Command -Expression $SB4    
Measure-Command -Expression $SB5    
