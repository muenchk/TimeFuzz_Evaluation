Grammar(
	'start := 'SEQ_option | 'start ~ 'SEQ_option,
	'SEQ_option := "[ " ~ 'right ~ 'z ~ 'x ~ 'down ~ " ]",
	'right := | " 'RIGHT', ",
	'z := | " 'Z', ",
	'x := | " 'X', ",
	'down := | " 'DOWN' ",
)