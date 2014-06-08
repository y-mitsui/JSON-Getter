<?php
require_once "jsonGetter.php";

$xpath_text="/root/data1";
$json=array('root' => array( 'data1' => 1, 'data2' => 2));

$ctx=new JsonGetter($xpath_text);
$result=$ctx->match($json);

for($i=0;$i<count($result);$i++){
	var_dump($result[$i]);
	unset($result[$i]) //modify $json as originlal too.
}
var_dump($json);
?>
