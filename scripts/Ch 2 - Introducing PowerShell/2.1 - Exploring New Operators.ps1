# 1.1 Exploring New Operators

# pipeline chain operators && and ||


# 1. Without Pipeline Chain operator
$FILE = 'C:\Foo\Ch1.log'
If (-Not [Bool](Get-ChildItem -Path $FILE)) {
  New-Item -Path $FILE 
}
Remove-Item -Path $FILE

# 2. With pipeline chain
Get-ChildItem -Path $FILE || New-Item -Path $FILE

# 2. Use || to test for pipeline failure
Get-ChildItem -Path 'C:\foo\ch1.log' || 
  Remove-Item -Path 'C:\foo\ch1.log' -Verbose


  # 3. combining it all

$sb1 = {

   Get-ChildItem -Path $FILE -ErrorAction SilentlyContinue || 
   $(New-Item -Path $FILE; 
     Add-Content -Value "Created" -Path $FILE) && 
       Get-Content -Path $FILE

}

Trace-Command -EXP $sb1       