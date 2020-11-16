# 5.5 - Create a C# PowerShell Extension

# 1. Create the code in here string
$NewType = @"
 using System;
 class Program
 {

 public class Hello
 {
     public static void World() {
         Console.WriteLine("Hello World!");
     }
 }
"@

# 2. Adding the type into the current PowerShell session
Add-Type -TypeDefinition $NewType

# 3. Using the newly created class
[Hello]::World()

# 4. Extending the code with parameters
$NewType2 = @"
using System;
using System.IO;

public class Hello2  {
  public static void World() {
    Console.WriteLine("Hello World!");
  }
  public static void World(string name) {
    Console.WriteLine("Hello " + name + "!");
  }
}
"@

# 5. Adding the type into the current PowerShell session
Add-Type -TypeDefinition $NewType2 -Verbose

# 6. Using the newly created class
[Hello2]::World('Jerry')

# 7. Callling with NO parameters specified
[Hello2]::World()
