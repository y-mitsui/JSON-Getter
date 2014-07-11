%declare_class { class SelectParser}
%syntax_error { echo "SYNTAX ERROR!\n"; }
%include_class {
	const ABSOLUTE = 1;
	const RELATIVE = 2;
	const N_NORMAL = 1;
	const N_ATTRIBUTE = 2;
	const N_FUNCTION = 3;
	const N_REGEX = 4;
	
	public $result_root;
	public function addCondition($type,$left,$right) {
		return array( 'type' => $type , 'left' => $left , 'right' => $right);
	}
	public function addNode($type,$name,$condition){
		return array( 'type' => $type , 'name' => $name , 'condition' => $condition , 'next' => null);
	}
	public function makeName($type,$value){
		return array( 'type' => $type , 'value' => $value);
	}
	public function addSyntax($prev,$next){
		$prev['next']=$next;
		return $prev;
	}
	private function trim($str){
		$let=substr($str,1);
		return substr($let,0,strlen($let)-1);
	}
}
/*
	jsonSelector
	/images/<^[0-9]+$>[images/value()='public' and images/value()='ofz']
*/
%left EQUAL.
%left M_OR M_AND.
program ::= selectors(A).{ $this->result_root=A; }
selectors(A) ::= root_elements(B) . {  A=B;   }
selectors(A) ::= . { A=null; }
root_elements(A) ::= root_element(B) root_elements(C) .{ A=$this->addSyntax(B,C); }
root_elements(A) ::= .{ A=null;}
root_element(A) ::= SLASH SLASH element_name(B) condition(C).{ A=$this->addNode(SelectParser::RELATIVE,B,C);  }
/*root_element(A) ::= SLASH ALPHA_NUM(B) condition(C).{  A=$this->addNode(SelectParser::ABSOLUTE,B,C); }
root_element(A) ::= SLASH M_FUNCTION(B) .{ A=$this->addNode(ABSOLUTE,B,null); }*/
root_element(A) ::= SLASH element_name(B) condition(C).{ A=$this->addNode(SelectParser::ABSOLUTE,B,C); }
element_name(A) ::= ALPHA_NUM(B).{ A=$this->makeName(SelectParser::N_NORMAL,B); }
element_name(A) ::= ATMARK ALPHA_NUM(B).{ A=$this->makeName(SelectParser::N_ATTRIBUTE,B); }
element_name(A) ::= M_FUNCTION(B).{ A=$this->makeName(SelectParser::N_FUNCTION,B); }
element_name(A) ::= M_REGEX(B).{ A=$this->makeName(SelectParser::N_REGEX,$this->trim(B)); }
syntax(A) ::= ALPHA_NUM(B) condition(C) SLASH.{ A=$this->addNode(SelectParser::ABSOLUTE,B,C); }
syntax(A) ::= SLASH SLASH ALPHA_NUM(B) condition(C).{  A=$this->addNode(SelectParser::RELATIVE,B,C);  }
syntax(A) ::= .{ A=null;  }

element_name(A) ::= ALPHA_NUM(B). { A=makeName('leteral',B); }
element_name(A) ::= REGEX(B).{ A=makeName('regex',B); }
condition(A) ::= LBACKET expr(B) RBACKET . { A=B; }
condition(A) ::= . {A=null;}
expr(A) ::= expr(B) M_AND expr(C).{A=$this->addCondition(SelectParser::M_AND,B,C); }
expr(A) ::= expr(B) M_OR expr(C).{ A=$this->addCondition(SelectParser::M_OR,B,C); }
expr(A) ::= expr(B) TIMES expr(C).{ A=$this->addCondition(SelectParser::M_OR,B,C); }
expr(A) ::= expr(B) MINUS expr(C).{ A=$this->addCondition(SelectParser::M_OR,B,C); }
expr(A) ::= expr(B) PLUS expr(C).{ A=$this->addCondition(SelectParser::M_OR,B,C); }
expr(A) ::= expr(B) LG NUMERAL(C).{ A=$this->addCondition(SelectParser::LG,B,C); }
expr(A) ::= root_elements(B) EQUAL LETERAL(C) .{ 
	A=$this->addCondition(SelectParser::EQUAL,B,$this->trim(C)); 
}
expr(A) ::= LPAREN expr(B) RPAREN.{ A=B; }
expr(A) ::= element_name(B) root_elements(C) EQUAL LETERAL(D) .{
	echo "aaa\n\n";
	$tmp=$this->addNode(SelectParser::RELATIVE,B,null);
	$tmp2=$this->addSyntax($tmp,C);
	A=$this->addCondition(SelectParser::EQUAL,$tmp2,$this->trim(D)); 
}
