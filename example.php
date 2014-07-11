<?php
require_once "jsonGetter.php";

/*********
 * 
 *  [example1]
 * 
 * ********/
$xpath_text="/root/data1[aaa='1']";
$json=json_decode('{"root":{"data1":{"aaa":"1"},"data2":"2"}}',true);

var_dump($json);
$ctx=new JsonGetter($xpath_text);
$result=$ctx->match($json);

echo count($result)."\n";
for($i=0;$i<count($result);$i++){
	var_dump($result[$i]);
	unset($result[$i]); //modify $json as originlal too.
}
var_dump($json);
?>
