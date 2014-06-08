JSON-Getter for PHP
==========
A Json selector like XPath written by PHP

## Install
1. install PHP_LexerGenerator and PHP_ParserGenerator of latest version.  
    $ pear install PHP_ParserGenerator-0.1.7  
> pear install PHP_LexerGenerator-0.4.0  

2. If your installing version is 0.4.0 of PHP_LexerGenerator,You must do bagfix of core this following.  
> vi /usr/local/lib/php/PHP/LexerGenerator/Parser.php # (Path is case-by-case)  
[befor]  

    fwrite($this->out, '$yy_global_pattern = \'' .  
    $pattern . '\';' . "\n");  

[after]  
<pre>
> fwrite($this->out, '$yy_global_pattern = "' .  
>             $pattern . '";' . "\n");  
</pre>

3. Input this following on shell  
> phplemon selectParser.y  

## Usage
Read example.php
