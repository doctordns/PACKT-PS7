# 5.5 - Create a .NET Extension

# 1. Create the code in here string
$NewType = @"
 using System;
 public class Hello
 {
     public static void World() {
         Console.WriteLine("Hello World!");
     }
 }
"@

# 2. Add the type into the current runspace
Add-Type -TypeDefinition $NewType

# 3. Use the newly created class
[Hello]::World()


# 4. Extend the code with parameters
$NewType2 = @"
 using System;
 class Hello2  {
     public static void World(string name = "Thomas") {
        Console.WriteLine("Hello " + name);
     }
} 
"@

# 5. Add the type into the current runspace
Add-Type -TypeDefinition $NewType2 -Verbose

# 6. Use the newly created class
[Hello2]::World('Jerry')

# 7. Call with NO parameters specified
[Hello2]::World()
