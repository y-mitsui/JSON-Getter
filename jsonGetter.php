<?php

require_once "PHP/LexerGenerator.php";
new PHP_LexerGenerator('selectLexer.plex');

require_once "selectParser.php";

require_once "selectLexer.php";

class JsonGetter{
	private $parser;
	private $condition_root;

	public function __construct($syntax) {
		$this->parser = new SelectParser();
		$this->condition_root=$this->parse($syntax);
	}
	public function match($json){
		$matchingElements=array();
		__match($json,$condition_root,$matchingElements);
		return $matchingElements;
	}
	function parse($syntax){

		$lexer=new SelectLexer($syntax);
		while ($lexer->yylex()) {
			$this->parser->doParse($lexer->token, $lexer->value);
		}
		$parser->doParse(0, 0);
		return $this->parser->result_root;
	}
	function condition($cond,$json){
		switch ($cond['type']){
		case M_AND:
			return $this->condition($cond['left'],$json) && $this->condition($cond['right'],$json);
		case EQUAL:
			$matched=array();
			$this->match($json,$cond['left'],$matched);
			for($i=0;$i<count($matched);$i++){
				if(($matched[$i]==$cond['right'])) return true;
			}
			return false;
		}
	}
	function matchName($name,$condition){
		switch($condition['type']){
		case N_REGEX:
			return ereg($condition['value'],$name);
		case N_NORMAL:
			return $name==$condition['value'];
		}
	}
	function __match($json,$node,&$res){
		if($node['name']['type']==N_FUNCTION){
			$res[]=$json;
			return ;
		}
		if(!is_array($json)) return;
		foreach($json as $k => $v){
			if($this->matchName($k,$node['name']) && (!$node['condition'] || $this->condition($node['condition'],$json[$k]))){
				if($node['next'])
					$this->__match($json[$k],$node['next'],$res); 
				else
					$res[$k]=$json[$k];
			}elseif($node['type']=RELATIVE)
				$this->__match($json[$k],$node,$res); 
		}
	}
}
