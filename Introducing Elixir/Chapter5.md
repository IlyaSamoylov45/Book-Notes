Chapter 5 Communicating with Humans

Strings
  - Elixir uses the unusual-looking but functional <> operator:

     ```Elixir
     iex(3)> "el" <> "ixir"
             "elixir"
     iex(4)> a="el"
             "el"
     iex(5)> a <> "ixir"
             "elixir"
     ```

     ```Elixir
     iex(1)> a = "this"
             "this"
     iex(2)> b = "The value of a is #{a}."   
                 "The value of a is this."
     iex(3)> a = "that"
                 "that"
     iex(4)> b
             "The value of a is this."
     ```

Multiline Strings
- Unlike regular strings, multiline strings open and close with three double quotes:

   ```Elixir
   iex(1)> multi = """
   ...(1)> This is a multiline
   ...(1)> string, also called a heredoc.
   ...(1)> """
   "This is a multiline\nstring, also called a heredoc.\n"
   ```

Character Lists
  - You concatenate character lists with ++ instead of <>:
  - You can convert character lists to strings with List.to_string/1 and strings to character lists with String.to_char_list/1

String Sigils
  - Sigils start with a ~ sign, then one of the letters s (for binary string), c (for character list), r (for regular expression), or w (to produce a list split into words by whitespace). If the letter is lowercase, then interpolation and escaping happen as usual. If the letter is uppercase (S, C, R, or W), then the string is created exactly as shown, with no escaping or interpolation.
  - Elixir also offers w and W, for lists of words. This sigil takes a binary string and splits it into a list of strings separated by whitespace.

Gathering Characters
  - The IO.getn function will let you get just a few characters from the user.

Reading Lines of Text
  - The IO.gets function waits for the user to enter a complete line of text terminated by a newline.
  
